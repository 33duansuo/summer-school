module password_reg(
    input identity,    // user'1' / admininstrator'0'  
    input state,       // two states: '0': waiting, '1': editing 
    input edit_switch, // toggle it before entering password 
    input load, // to load one digit (left-shift), posedge trigger
    input del, // to delete one digit (right-shift), posedge trigger
	input[3:0] one_digit, // the one decimal digit you input
    //input ok,     // press (=0) it when you finish entering
    //output ok_signal, // to the system logic
    output reg [15:0] q, // the shift reg that loads password
    output reg [15:0] new_pswd, // the new password you set,when"identity==0"
    reg left_shift // to left-shift the reg
    );
    always @(posedge load)// posedge trigger to load one digit
    begin
        if(left_shift==0&one_digit<10)
            left_shift <= 1;
        else
        if(left_shift==1&one_digit<10)
            left_shift <= 2;

        else
        if(left_shift==2&one_digit<10)
            left_shift <= 3;

        else
        if(left_shift==3&one_digit<10)
            left_shift <= 0;
        else
        if(left_shift==3&one_digit>=10)
            left_shift <= 2;
        else
        if(left_shift==2&one_digit>=10)
            left_shift <= 1;
        else
        if(left_shift==1&one_digit>=10)
            left_shift <= 0;
        else
        if(left_shift==0&one_digit>=10)
            left_shift <= 3;
    end
always @(posedge one_digit)//when one_digit changes, load it into the q reg
    if(identity==1) // user
    begin
            if(left_shift==0)
                q[3:0] <= one_digit;
            else
            if(left_shift==1)    
                q[7:4] <= one_digit;
            else    
            if(left_shift==2)    
                q[11:8] <= one_digit;
            else        
            if(left_shift==3)           

                q[15:12] <= one_digit;
    

    /*TODO
    implement a shift register;
    always @(mode_switch) state = 1;
    assign ok_signal = ok;  // inform the system logic to proceed to password check
    */
   else if(identity==0) //administrator
    begin
            if(left_shift==0)
                new_pswd[3:0] <= one_digit;
            else
            if(left_shift==1)    
                new_pswd[7:4] <= one_digit;
            else    
            if(left_shift==2)    
                new_pswd[11:8] <= one_digit;
            else        
            if(left_shift==3)           

                new_pswd[15:12] <= one_digit;
    end 
end

endmodule

module password_check (
    input identity,  // user'1' / admin '0' , only when identity==1 will this module be enabled
    input ok_signal, // when posedge, check the password
    input wire [15:0] q,    // the password you input
    input wire [15:0] correct_pswd, // the correct password 
    // input admin_buttion,  // clear the alarm signal, posedge trigger
    output result // '1': right '0': wrong 
);
if 

    /*TODO:          
        check the password;        
    */
    
endmodule

/* module password_set (  // set the password
    input identity,   // user'1' / admin '0' , only when identity==0 will this module be enabled 
    input ok_signal,  // when posedge, set the password
    input wire  [15:0] q,
    output reg [15:0] new_pswd
); */
    
//endmodule

module decoder (   // read the 16 bits in the register, do a binary-to-dec transition
    input[16:0] bits,
    input  correct,
    output reg [7:0] sel,  // select the digit you want to display
    output reg [7:0] tubes, //
    wire   [3:0] A,A1,A2,A3,
    wire A4,
    ); // the 4-bit binary number to display

    assign A=bits[3:0];
    assign A1=bits[7:4];
    assign A2=bits[11:8];
    assign A3=bits[15:12];
    assign A4=correct,
always @(A)
begin
sel <= 8'b11111110; //one tubes to display the first decimal digit
case(A)
4'b0000 : tubes <= 7'b1000_000;//7'b0111_111;//
4'b0001 : tubes <= 7'b1111_001;//7'b0000_110;
4'b0010 : tubes <= 7'b0100_100;//7'b1011_011;
4'b0011 : tubes <= 7'b0110_000;//7'b1001_111;
4'b0100 : tubes <= 7'b0011_001;//7'b1100_110;
4'b0101 : tubes <= 7'b0010_010;//7'b1101_101;
4'b0110 : tubes <= 7'b0000_010;//7'b1111_101;
4'b0111 : tubes <= 7'b1111_000;//7'b0000_111;
4'b1000 : tubes <= 7'b0000_000;//7'b1111_111;
4'b1001 : tubes <= 7'b0010_000;//7'b1101_111;
default : tubes <= 7'b1000_000;//7'b0111_111;
endcase
end
always @(A1)
begin
sel <= 8'b11111101; //two tubes to display the second decimal digit
case(A1)
4'b0000 : tubes <= 7'b1000_000;//7'b0111_111;//
4'b0001 : tubes <= 7'b1111_001;//7'b0000_110;
4'b0010 : tubes <= 7'b0100_100;//7'b1011_011;
4'b0011 : tubes <= 7'b0110_000;//7'b1001_111;
4'b0100 : tubes <= 7'b0011_001;//7'b1100_110;
4'b0101 : tubes <= 7'b0010_010;//7'b1101_101;
4'b0110 : tubes <= 7'b0000_010;//7'b1111_101;
4'b0111 : tubes <= 7'b1111_000;//7'b0000_111;
4'b1000 : tubes <= 7'b0000_000;//7'b1111_111;
4'b1001 : tubes <= 7'b0010_000;//7'b1101_111;
default : tubes <= 7'b1000_000;//7'b0111_111;
endcase
end
always @(A2)
begin
sel <= 8'b11111011; //three tubes to display the third decimal digit
case(A2)
4'b0000 : tubes <= 7'b1000_000;//7'b0111_111;//
4'b0001 : tubes <= 7'b1111_001;//7'b0000_110;
4'b0010 : tubes <= 7'b0100_100;//7'b1011_011;
4'b0011 : tubes <= 7'b0110_000;//7'b1001_111;
4'b0100 : tubes <= 7'b0011_001;//7'b1100_110;
4'b0101 : tubes <= 7'b0010_010;//7'b1101_101;
4'b0110 : tubes <= 7'b0000_010;//7'b1111_101;
4'b0111 : tubes <= 7'b1111_000;//7'b0000_111;
4'b1000 : tubes <= 7'b0000_000;//7'b1111_111;
4'b1001 : tubes <= 7'b0010_000;//7'b1101_111;
default : tubes <= 7'b1000_000;//7'b0111_111;
endcase
end
always @(A3)
begin
sel <= 8'b11110111; //four tubes to display the third decimal digit
case(A3)
4'b0000 : tubes <= 7'b1000_000;//7'b0111_111;//
4'b0001 : tubes <= 7'b1111_001;//7'b0000_110;
4'b0010 : tubes <= 7'b0100_100;//7'b1011_011;
4'b0011 : tubes <= 7'b0110_000;//7'b1001_111;
4'b0100 : tubes <= 7'b0011_001;//7'b1100_110;
4'b0101 : tubes <= 7'b0010_010;//7'b1101_101;
4'b0110 : tubes <= 7'b0000_010;//7'b1111_101;
4'b0111 : tubes <= 7'b1111_000;//7'b0000_111;
4'b1000 : tubes <= 7'b0000_000;//7'b1111_111;
4'b1001 : tubes <= 7'b0010_000;//7'b1101_111;
default : tubes <= 7'b1000_000;//7'b0111_111;

always @(A4)
begin
sel <= 8'b11101111; //four tubes to display the third decimal digit
case(A4)
1'b0 : tubes <= 7'b1000_000;//7'b0111_111;//
1'b1 : tubes <= 7'b1111_001;//7'b0000_110;
default : tubes <= 7'b1000_000;//7'b0111_111;
endcase
end
    /*TODO: bin->dec transition, display it on the digital tubes*/

endmodule

module counter (
    input error_signal,
    output[1:0] count // 
);
    /*TODO:
    implement a counter that counts the time you enter the wrong password
    */
endmodule

module system_logic (  // manages the overall logic of the lock, **it should be the top module**
    input [3:0] switches, // represent a decimal 0~9
    input edit_switch,    // when changed, break the waiting mode
    input load, // load one digit
    input del,  // delete one digit
    input ok_button,   // confirm button
    input admin_buttion,  // clear the alarm signal, posedge trigger
    output[1:0] state_out, // 4 states: 00 waiting, 01:editing, 10:unlocked, 11:alarming
    output[7:0] tubes, // LED tubes that display the passwords you entered
    output[3:0] LEDs  // the LEDs that indicates the state of the lock
);
    reg[15:0] password;
    reg[15:0] correct_pswd;
    reg[1:0] state0 = 2'b00;
    wire check_result;
    wire[1:0] time_of_error;
    reg identity = 1'b1; // 0-admin, 1-user

    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unclocked = 2'b10;
    parameter alarming = 2'b11;
    parameter user = 1'b1;
    parameter admin = 1'b0;

always @(admin_buttion) 
begin
    if(identity == 0)// press button to change the identity(0-1)
    identity = 1;//admin
    else
    identity = 0;//user
end


    password_reg pswd_reg( 
        .identity(identity),
        .state(state0),
        .edit_switch(edit_switch),
        .load(load),
        .del(del),
        .one_digit(switches),
        .q(password),
        .new_pswd(correct_pswd)
    );
    
    password_check pswd_check(
        .identity(identity),
        .ok_signal(ok_signal),
        .q(password),
        .correct_pswd(correct_pswd),
        .result(check_result)
    );

   /*  password_set pswd_set(
        .identity(identity),
        .ok_signal(ok_signal),
        .q(password),
        .new_pswd(correct_pswd)
    ); */
    decoder u_decoder(
        .bits  (q  ),
        .sel   (sel   ),
        .tubes (tubes ),
        .A     (A     ),
        .A1    (A1    ),
        .A2    (A2    ),
        .A3    (A3    ),
        .A4    (A4    ),
        .correct(check_result),
    );
    

    

    counter count(
        .error_signal(check_result),
        .count(time_of_error)
    );

    timer timer_(
        .state(state0),
        .ok(ok_signal),
        .clk(clk),
        .pulse()
    );

    state_indicate indicate(
        .state(state0),
        .ok(ok_signal),
        .LEDs(LEDs)
    );

    /*TODO:
    implement the logics
    */
    always @(edit_switch) begin
        if (state0 == waiting) state0 = editing;
    end
    // to be completed...
    

    
endmodule

module timer ( 
    input[1:0] state, // 4 states: 00 waiting, 01:editing, 10:unlocked, 11:alarming
    input ok,       // press the button to transfer to waiting mode when unlocked
    input clk,      // a standard square wave signal
    output pulse   // when the timing ends, given an postive pulse to the system_logic 
    //output new_state //
);
    /*TODO:
    waiting/alarming: do nothing;
    editing: set a 10s timing, then return to waiting mode;
    unlocked: set a 20s timing, when timing ends or posedge ok, return to waiting mode;
    */
    
endmodule

module state_indicate ( // control the LEDs
    //ports
    input[1:0] state,
    //output[7:0] tubes,
    output[3:0] LEDs 
);
    /*TODO:
    unclocked: turn on all LEDs;
    alarming:  all LEDs flashing;
    waiting:  turn on one LED;
    editing:  turn on two LEDs;
    */
endmodule