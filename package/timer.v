module timer ( 
    input[1:0] state, // 4 states: 00 waiting, 01:editing, 10:unlocked, 11:alarming
    input ok,       // press the button to transfer to waiting mode when unlocked
    input clk,      // a standard square wave signal
    input [3:0]switches,
    input load,
    input admin_button,
   // when the timing ends, given an postive pulse to the system_logic 
    //output new_state //
    output reg finished
);
    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unlocked = 2'b10;
    parameter alarming = 2'b11;
reg [31:0] cnt_1ms;
reg [31:0] cnt_1s;
reg [31:0] cnt;
always @(ok,switches,load,admin_button) 
begin
    cnt_1s<=0;
end

always @(posedge clk)
 begin
 if(cnt == 32'd49999)					   //计时�?
		cnt_1ms <= cnt_1ms+1;							//清零计时
 else										//计时未到
		cnt <= cnt + 1;					//继续计时
 end

 always @(cnt_1ms) 
 begin
 if(cnt_1ms == 32'd1000)					   //计时�?
		cnt_1s <= cnt_1s+1;							//清零计时
 else										//计时未到
		cnt_1ms <= cnt_1ms + 1;					//继续计时

    if  (cnt_1s==32'd10&&state==editing)
    finished <= 1'b1;
    else if  (cnt_1s==32'd20&&state==unlocked)
    finished <= 1'b1;
 end


    /*TODO:
    waiting/alarming: do nothing;
    editing: set a 10s timing, then return to waiting mode;
    unlocked: set a 20s timing, when timing ends or posedge ok, return to waiting mode;
    */
    
endmodule