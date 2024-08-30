module password_reg(
    input clk,
    input identity,    // user'1' / admininstrator'0'  
    input state,       // two states: '0': waiting, '1': editing 
    input edit_switch, // toggle it before entering password 
    input load, // to load one digit (left-shift), posedge trigger
	input[3:0] one_digit, // the one decimal digit you input
    input[1:0] time_of_error,
    output reg [15:0] q, // the shift reg that loads password
    output reg [15:0] new_pswd, // the new password you set,when"identity==0"
    output reg [6:0] tubesreg, // the tubes to display the first decimal digit
    output reg [7:0] sel //
    );
    reg [3:0]left_shift;
    reg[31:0] cnt_1ms;

    always @(posedge load)// posedge trigger to load one digit
    begin
        if(left_shift==0 && one_digit<10)
            left_shift <= 4'd1;
        
        else if(left_shift==1 && one_digit<10)
            left_shift <= 4'd2;

        
        else if(left_shift==2 && one_digit<10)
            left_shift <= 4'd3;
        
        else if(left_shift==3 && one_digit<10)
            left_shift <= 4'd0;
        
        else if(left_shift==3 && one_digit>=10)
            left_shift <= 4'd2;
        
        else if(left_shift==2 && one_digit>=10)
            left_shift <= 4'd1;
        
        else if(left_shift==1 && one_digit>=10)
            left_shift <= 4'd0;
        
        else if(left_shift==0 && one_digit>=10)
            left_shift <= 4'd3;
    end

 always @(one_digit)//when one_digit changes, load it into the q reg
 begin
    if(identity==1) // user
    begin
            if(left_shift==4'd0)
                q[3:0] <= one_digit;
            
            else if(left_shift==4'd1)    
                q[7:4] <= one_digit;
               
            else if(left_shift==4'd2)    
                q[11:8] <= one_digit;
                    
            else if(left_shift==4'd3)           
                q[15:12] <= one_digit;
    end

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

    if(sel==8'b10111111||sel==8'b01111111)
    begin
      tubesreg <= 7'b1000_000;
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

    if(sel==8'b11011111||sel==8'b10111111||sel==8'b01111111)
    begin
    tubesreg <= 7'b1000_000;
    end
    end
 end
endmodule