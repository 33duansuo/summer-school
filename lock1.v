module ERZP (CLK, KIN,KOUT);
input CLK, KIN; //工作时钟和输入信�??
output KOUT; reg KOUT;
reg [7:0] KH,KL; //定义对高电平和低电平脉宽计数之寄存器
always @(posedge CLK) begin
if (!KIN) KL<=KL+1 ; //对键输入的低电平脉宽计数
else KL<=8'b00000000; end //若出现高电平, 则计数器清零
always @(posedge CLK) begin
if (KIN) KH<= KH+1; //同时对键输入的高电平脉宽计数
else KH<=8'b00000000; end //若出现高电平, 则计数器清零
always @(posedge CLK) begin
     if (KH > 8'b00111111) KOUT<=1'B1;//对高电平脉宽计数�??旦大�??12, 则输�??1 
else if (KL > 8'b00111000) KOUT<=1'B0; //对低电平脉宽计数若大�??7, 则输�??0
end
endmodule

module password_reg(
    input clk,
    input identity,    // user'1' / admininstrator'0'  
    input load, // to load one digit (left-shift), posedge trigger
	input[3:0] one_digit, // the one decimal digit you input
    input[1:0] time_of_error,
    input[31:0]cnt_1s,
    output reg [15:0] q, // the shift reg that loads password
    output reg [15:0] new_pswd, // the new password you set,when"identity==0"
    output reg [6:0] tubesreg, // the tubes to display the first decimal digit
    output reg [7:0] sel //
    );
    reg [3:0]left_shift;
    reg[31:0] cnt_1ms;

    always @(negedge load)// posedge trigger to load one digit
    begin
        if(left_shift==4'd0 && one_digit<4'd10)
            left_shift <= 4'd1;
        
        else if(left_shift==4'd1 && one_digit<4'd10)
            left_shift <= 4'd2;

        
        else if(left_shift==4'd2 && one_digit<4'd10)
            left_shift <= 4'd3;

        
        else if(left_shift==4'd3 && one_digit<4'd10)
            left_shift <= 4'd0;
        
        else if(left_shift==4'd3 && one_digit>=4'd10)
            left_shift <= 4'd2;
        
        else if(left_shift==4'd2 && one_digit>=4'd10)
            left_shift <= 4'd1;
        
        else if(left_shift==4'd1 && one_digit>=4'd10)
            left_shift <= 4'd0;
        
        else if(left_shift==4'd0 && one_digit>=4'd10)
            left_shift <= 4'd3;
    end

 always @(one_digit)//when one_digit changes, load it into the q reg
 begin
    if(identity==1) // user
    begin
            if(left_shift==4'd0)
                q[3:0] = one_digit;
            
            else if(left_shift==4'd1)    
                q[7:4] = one_digit;
               
            else if(left_shift==4'd2)    
                q[11:8] = one_digit;
                    
            else if(left_shift==4'd3)           
                q[15:12] = one_digit;
            else
                q=q;
    end

    /*TODO
    implement a shift register;
    always @(mode_switch) state = 1;
    assign ok_signal = ok;  // inform the system logic to proceed to password check
    */
   else if(identity==0) //administrator
    begin
            if(left_shift==4'd0)
                new_pswd[3:0] = one_digit;
            else
            if(left_shift==4'd1)    
                new_pswd[7:4] = one_digit;
            else    
            if(left_shift==4'd2)    
                new_pswd[11:8] = one_digit;
            else        
            if(left_shift==4'd3)           

                new_pswd[15:12] = one_digit;
            else
                new_pswd=new_pswd;
    end 
 end

 always @(posedge clk)
 begin
 if(cnt_1ms == 49_999)					   //计时�?
		cnt_1ms <= 0;							//清零计时
 else										//计时未到
		cnt_1ms <= cnt_1ms + 1;					//继续计时
 if (!load)
        sel <= 8'b11111110;
 else if(cnt_1ms == 49_999)					//计时�?
		sel <= {sel[6:0],sel[7]};	//位�?�信号左�?1�?		
 else
		sel <= sel;	
  end


 always @(posedge clk)
 begin
 if(identity==1) // user
 begin
  if(sel==8'b11111110)
  begin
        case(q[3:0])
            4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
            4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
            4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
            4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
            4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
            4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
            4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
            4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
            4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
            4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
            default : tubesreg <= 7'b1000_000;//7'b0111_111;
     endcase
  end
                if(sel==8'b11111101)
                begin
                        case(q[7:4])
                                4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                                4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                                4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                                4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                                4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                                4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                                4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                                4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                                default : tubesreg <= 7'b1000_000;//7'b0111_111;
                        endcase
                end

                    if(sel==8'b11111011)
                    begin
                        case(q[11:8])
                            4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                            4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                            4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                            4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                            4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                            4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                            4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                            4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                            4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                            4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                            default : tubesreg <= 7'b1000_000;//7'b0111_111;
                        endcase
                    end


                        if(sel==8'b11110111)
                        begin
                                case(q[15:12])
                                    4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                                    4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                                    4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                    4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                    4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                                    4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                                    4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                                    4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                                    4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                                    4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                                    default : tubesreg <= 7'b1000_000;//7'b0111_111;
                                endcase
                        end
                            if(sel==8'b11101111)
                            begin
                            tubesreg <= 7'b1111_001;//user
                            end

                                if(sel==8'b11011111)
                                begin
                                case(time_of_error[1:0])
                                2'b00 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                                2'b01 : tubesreg <= 7'b1111_001;//7'b0000_110;
                                2'b10 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                2'b11 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                default : tubesreg <= 7'b1000_000;//7'b0111_111;
                                endcase
                                end

                                if(sel==8'b10111111)
                                    begin
                                        case(cnt_1s)
                                        32'd0 : tubesreg <= 7'b1000_000;
                                        32'd1 : tubesreg <= 7'b1111_001;
                                        32'd2 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                        32'd3 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                        32'd4 : tubesreg <= 7'b0011_001;//7'b1100_110;
                                        32'd5 : tubesreg <= 7'b0010_010;//7'b1101_101;
                                        32'd6 : tubesreg <= 7'b0000_010;//7'b1111_101;
                                        32'd7 : tubesreg <= 7'b1111_000;//7'b0000_111;
                                        32'd8 : tubesreg <= 7'b0000_000;//7'b1111_111;
                                        32'd9 : tubesreg <= 7'b0010_000;//7'b1101_111;
                                        32'd10 : tubesreg <= 7'b1000_000;
                                        32'd11 : tubesreg <= 7'b1111_001;
                                        32'd12 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                        32'd13 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                        32'd14 : tubesreg <= 7'b0011_001;//7'b1100_110;
                                        32'd15 : tubesreg <= 7'b0010_010;//7'b1101_101;
                                        32'd16 : tubesreg <= 7'b0000_010;//7'b1111_101;
                                        32'd17 : tubesreg <= 7'b1111_000;//7'b0000_111;
                                        32'd18 : tubesreg <= 7'b0000_000;//7'b1111_111;
                                        32'd19 : tubesreg <= 7'b0010_000;//7'b1101_111;
                                        default:tubesreg <= 7'b1000_000;
                                        endcase
                                    end
                                    if(sel==8'b01111111)
                                    begin
                                        case(cnt_1s)
                                        32'd10 : tubesreg <= 7'b1111_001;
                                        32'd11 : tubesreg <= 7'b1111_001;
                                        32'd12 : tubesreg <= 7'b1111_001;//7'b1011_011;
                                        32'd13 : tubesreg <= 7'b1111_001;//7'b1001_111;
                                        32'd14 : tubesreg <= 7'b1111_001;//7'b1100_110;
                                        32'd15 : tubesreg <= 7'b1111_001;//7'b1101_101;
                                        32'd16 : tubesreg <= 7'b1111_001;//7'b1111_101;
                                        32'd17 : tubesreg <= 7'b1111_001;//7'b0000_111;
                                        32'd18 : tubesreg <= 7'b1111_001;//7'b1111_111;
                                        32'd19 : tubesreg <= 7'b1111_001;//7'b1101_111;
                                        default:tubesreg <= 7'b1000_000;
                                        endcase
                                  end
  end
    if(identity==0) // admin
     begin
                    if(sel==8'b11111110)
                    begin
                        case(new_pswd[3:0])
                            4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                            4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                            4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                            4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                            4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                            4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                            4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                            4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                            4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                            4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                            default : tubesreg <= 7'b1000_000;//7'b0111_111;
                        endcase
                    end
                    if(sel==8'b11111101)
                    begin
                        case(new_pswd[7:4])
                                4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                                4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                                4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                                4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                                4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                                4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                                4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                                4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                                4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                                4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                                default : tubesreg <= 7'b1000_000;//7'b0111_111;
                        endcase
                    end

                if(sel==8'b11111011)
                begin
                    case(new_pswd[11:8])
                        4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                        4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                        4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                        4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                        4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                        4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                        4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                        4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                        4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                        4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                        default : tubesreg <= 7'b1000_000;//7'b0111_111;
                    endcase
                end


                if(sel==8'b11110111)
                begin
                    case(new_pswd[15:12])
                        4'b0000 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                        4'b0001 : tubesreg <= 7'b1111_001;//7'b0000_110;
                        4'b0010 : tubesreg <= 7'b0100_100;//7'b1011_011;
                        4'b0011 : tubesreg <= 7'b0110_000;//7'b1001_111;
                        4'b0100 : tubesreg <= 7'b0011_001;//7'b1100_110;
                        4'b0101 : tubesreg <= 7'b0010_010;//7'b1101_101;
                        4'b0110 : tubesreg <= 7'b0000_010;//7'b1111_101;
                        4'b0111 : tubesreg <= 7'b1111_000;//7'b0000_111;
                        4'b1000 : tubesreg <= 7'b0000_000;//7'b1111_111;
                        4'b1001 : tubesreg <= 7'b0010_000;//7'b1101_111;
                        default : tubesreg <= 7'b1000_000;//7'b0111_111;
                    endcase
                end
                if(sel==8'b11101111)

                begin

                  tubesreg <= 7'b1000_000;//admin

                end

                    if(sel==8'b11011111)
                    begin
                        case(time_of_error[1:0])
                            2'b00 : tubesreg <= 7'b1000_000;//7'b0111_111;//
                            2'b01 : tubesreg <= 7'b1111_001;//7'b0000_110;
                            2'b10 : tubesreg <= 7'b0100_100;//7'b1011_011;
                            2'b11 : tubesreg <= 7'b0110_000;//7'b1001_111;
                            default : tubesreg <= 7'b1000_000;//7'b0111_111;
                        endcase
                    end

                    if(sel==8'b10111111)
                        begin
                            case(cnt_1s)
                            32'd0 : tubesreg <= 7'b1000_000;
                            32'd1 : tubesreg <= 7'b1111_001;
                            32'd2 : tubesreg <= 7'b0100_100;//7'b1011_011;
                            32'd3 : tubesreg <= 7'b0110_000;//7'b1001_111;
                            32'd4 : tubesreg <= 7'b0011_001;//7'b1100_110;
                            32'd5 : tubesreg <= 7'b0010_010;//7'b1101_101;
                            32'd6 : tubesreg <= 7'b0000_010;//7'b1111_101;
                            32'd7 : tubesreg <= 7'b1111_000;//7'b0000_111;
                            32'd8 : tubesreg <= 7'b0000_000;//7'b1111_111;
                            32'd9 : tubesreg <= 7'b0010_000;//7'b1101_111;
                            32'd10 : tubesreg <= 7'b1000_000;
                            32'd11 : tubesreg <= 7'b1111_001;
                            32'd12 : tubesreg <= 7'b0100_100;//7'b1011_011;
                            32'd13 : tubesreg <= 7'b0110_000;//7'b1001_111;
                            32'd14 : tubesreg <= 7'b0011_001;//7'b1100_110;
                            32'd15 : tubesreg <= 7'b0010_010;//7'b1101_101;
                            32'd16 : tubesreg <= 7'b0000_010;//7'b1111_101;
                            32'd17 : tubesreg <= 7'b1111_000;//7'b0000_111;
                            32'd18 : tubesreg <= 7'b0000_000;//7'b1111_111;
                            32'd19 : tubesreg <= 7'b0010_000;//7'b1101_111;
                            default:tubesreg <= 7'b1000_000;
                            endcase
                        end
                    if(sel==8'b01111111)
                    begin
                        case(cnt_1s)
                        32'd10 : tubesreg <= 7'b1111_001;
                        32'd11 : tubesreg <= 7'b1111_001;
                        32'd12 : tubesreg <= 7'b1111_001;//7'b1011_011;
                        32'd13 : tubesreg <= 7'b1111_001;//7'b1001_111;
                        32'd14 : tubesreg <= 7'b1111_001;//7'b1100_110;
                        32'd15 : tubesreg <= 7'b1111_001;//7'b1101_101;
                        32'd16 : tubesreg <= 7'b1111_001;//7'b1111_101;
                        32'd17 : tubesreg <= 7'b1111_001;//7'b0000_111;
                        32'd18 : tubesreg <= 7'b1111_001;//7'b1111_111;
                        32'd19 : tubesreg <= 7'b1111_001;//7'b1101_111;
                        default:tubesreg <= 7'b1000_000;
                        endcase
                   end
      end
  end
endmodule



module password_check (
    input identity,  // user'1' / admin '0' , only when identity==1 will this module be enabled
    input ok_signal, // when posedge, check the password
    input  [15:0] password,    // the password you input
    input  [15:0] correct_pswd, // the correct password
    // input admin_buttion,  // clear the alarm signal, posedge trigger
    output reg result, // '1': right '0': wrongs
    output reg [1:0]time_of_error 
);
 always @(negedge ok_signal) 
 begin
  if (password==correct_pswd && identity==1) // user
  begin
    result <= 1'b1; // right
    time_of_error <= 2'b00; // no error
  end
  else if (password!=correct_pswd && identity==1) // user
  begin
    result <= 1'b0; // wrong
    time_of_error <= time_of_error+2'b01; // error happened
  end

  else if (identity==0) // admin
  begin
    time_of_error <= 2'b00; // no error
  end
 end




    /*TODO:          
        check the password;        
    */
    
endmodule

/* module password_set (  // set the password
    input identity,   // user'1'  admin '0' , only when identity==0 will this module be enabled 
    input ok_signal,  // when posedge, set the password
    input wire  [15:0] q,
    output reg [15:0] new_pswd
); */
    
//endmodule

/* module counter (
    input error_signal,
    output[1:0] count // 
); */
    /*TODO:
    implement a counter that counts the time you enter the wrong password
    */


module system_logic (  // manages the overall logic of the lock, **it should be the top module**
    input clk, // the clock signal
    input [3:0] switches, // represent a decimal 0~9
    input load, // load one digit
    input ok_button,   // confirm button
    input admin_button,  // clear the alarm signal, posedge trigger
    input key_button,
    output[6:0] tubes, // LED tubes that display the passwords you entered
    output[3:0] LEDs,  // the LEDs that indicates the state of the lock
    output[7:0] sel   // select the digit you want to display
);
    wire[15:0] password;
    wire[15:0] correct_pswd;
    wire[6:0] tubes_temp;
    wire[31:0] cnttemp;
    reg[1:0] state = 2'b00;
    reg[1:0] next_state;
    wire check_result;
    wire[1:0] time_of_error;
    reg identity = 1'b1; // 0-admin, 1-user
    wire load_button;
    wire admin_temp;
    wire ok_signal;
    wire key;
    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unlocked = 2'b10;
    parameter alarming = 2'b11;
    parameter user = 1'b1;
    parameter admin = 1'b0;

always @ (posedge admin_temp) 
begin
if(identity==1'b1)
   identity <= 1'b0; // admin
 else if(identity==1'b0)
   identity <= 1'b1; // user
end


    ERZP u_ERZP(
        .CLK  (clk),
        .KIN  (load),
        .KOUT (load_button)
    );
     ERZP u_ERZP1(
        .CLK  (clk),
        .KIN  (admin_button),
        .KOUT (admin_temp)
    );
     ERZP u_ERZP2(
        .CLK  (clk),
        .KIN  (ok_button),
        .KOUT (ok_signal)
    );
     ERZP u_ERZP3(
        .CLK  (clk),
        .KIN  (key_button),
        .KOUT (key)
    );

    password_reg pswd_reg( 
        .clk(clk),
        .identity(identity),
        .time_of_error(time_of_error),
        .cnt_1s(cnttemp),
        .load(load_button),
        .one_digit(switches),
        .q(password),
        .new_pswd(correct_pswd),
        .tubesreg(tubes),
        .sel(sel)
    );
    
    
    password_check pswd_check(
        .identity(identity),
        .ok_signal(ok_signal),
        .password(password),
        .correct_pswd(correct_pswd),
        .result(check_result),
        .time_of_error(time_of_error)
    );
/*     counter count(
        .error_signal(check_result),
        .count(time_of_error)
    ); */

   timer u_timer(
    .state        (state),
    .ok           (ok_signal),
    .clk          (clk),
    .switches     (switches),
    .load         (load_button),
    .admin_button (admin_temp),
    .key          (key),
    .cnttemp      (cnttemp),
    .finished     (finished)
   );
   
   state_indicate u_state_indicate(
    .state (state),
    .LEDs  (LEDs)
   );

   always @(posedge clk) begin
        next_state = state; // to avoid generating latch
        if (state == waiting &&(!key_button||!load)) begin 
            next_state = editing;
        end
        if (state == editing && finished == 1)begin // 10s no operation,back to waiting
            next_state = waiting;
        end
        if (state == editing && check_result == 1) begin // when you entered the right password
            next_state = unlocked;
        end
        if (state == unlocked && finished == 1) begin // 20s no operation,back to waiting
            next_state = waiting;
        end
        if (state == editing && time_of_error == 2'd3) begin // when you entered wrong password 3 times
            next_state = alarming;
        end
        if (state == alarming && !admin_button ) begin
            next_state = waiting;
        end
        if (state == unlocked && !key_button ) begin
            next_state = waiting;
        end
    end

    always @(posedge clk) 
    begin
      
     
            state <= next_state;
        
    end

    assign state_out = state;
    

    
endmodule

module timer ( 
    input[1:0] state, // 4 states: 00 waiting, 01:editing, 10:unlocked, 11:alarming
    input ok,       // press the button to transfer to waiting mode when unlocked
    input clk,      // a standard square wave signal
    input [3:0]switches,
    input load,
    input key,
    input admin_button,
    output reg [31:0]cnttemp,
    output reg finished
);
    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unlocked = 2'b10;
    parameter alarming = 2'b11;
    reg [31:0] cnt_1ms;
    reg [31:0] cnt;
    reg [31:0] cnt_1s;
    reg [3:0] lastone;
    always @(negedge clk) 
    begin
     lastone=switches;   
    end

    always @(posedge clk)
    begin
        if(!key||!load||!admin_button||!ok||lastone!=switches)
        begin
            cnt_1s<=0;
            cnt_1ms<=0;
        end
    cnttemp = cnt_1s;
    if(cnt == 32'd49999)					   //计时�?
    begin
            cnt_1ms <= cnt_1ms+1;
            cnt<=0;							//清零计时
    end
    else										//计时未到
            cnt <= cnt + 1;					//继续计时

    if(cnt_1ms == 32'd1000)					   //计时�?)
    begin
            cnt_1s <= cnt_1s+1;
            cnt_1ms<=0;							//清零计时
    end
    
        if  (cnt_1s==32'd10&&state==editing)
         begin
        finished <= 1'b1;
        cnt_1s <= 32'd0;
         end
        else if  (cnt_1s==32'd20&&state==unlocked)
        begin
        finished <= 1'b1;
        cnt_1s<=32'd0; 
        end
        if(state==waiting)
        finished <= 1'b0;
    end
endmodule

module state_indicate ( // control the LEDs
    //ports
    input[1:0] state,
    
    output reg [3:0] LEDs 
);
    /*TODO:
    unlocked: turn on all LEDs;
    alarming:  all LEDs flashing;
    waiting:  turn on one LED;
    editing:  turn on two LEDs;
    */
    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unlocked = 2'b10;
    parameter alarming = 2'b11;
    parameter user = 1'b1;
    parameter admin = 1'b0;
    always @(*) begin
        case (state)
            waiting: LEDs = 4'b0001;
            editing: LEDs = 4'b0011;
            alarming: LEDs = 4'b0111;
            unlocked: LEDs = 4'b1111;
            default: LEDs = 4'b0000;
        endcase
    end

endmodule