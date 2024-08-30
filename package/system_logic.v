module system_logic (  // manages the overall logic of the lock, **it should be the top module**
    input clk, // the clock signal
    input [3:0] switches, // represent a decimal 0~9
    input edit_switch,    // when changed, break the waiting mode
    input load, // load one digit
    input ok_button,   // confirm button
    input admin_button,  // clear the alarm signal, posedge trigger
    input key_button,
    output[6:0] tubes, // LED tubes that display the passwords you entered
    output[3:0] LEDs,  // the LEDs that indicates the state of the lock
    output[7:0] sel,   // select the digit you want to display
    output[1:0] state_out
);
    wire[15:0] password;
    wire[15:0] correct_pswd;
    wire[6:0] tubes_temp;
    reg[1:0] state0 = 2'b00;
    reg[1:0] next_state;
    wire check_result;
    wire[1:0] time_of_error;
    reg identity = 1'b1; // 0-admin, 1-user
    wire load_button;
    wire admin_temp;
    wire ok_signal;
    parameter waiting = 2'b00;
    parameter editing = 2'b01;
    parameter unlocked = 2'b10;
    parameter alarming = 2'b11;
    parameter user = 1'b1;
    parameter admin = 1'b0;
vio_0 vio(
  .clk(clk),              // input wire clk
  .probe_in0(correct_pswd),  // input wire [15 : 0] probe_in0
  .probe_in1(password),  // input wire [3 : 0] probe_in1
  .probe_in2(time_of_error),  // input wire [1 : 0] probe_in2
  .probe_in3(tubes)      // input wire [6 : 0] probe_in3
);

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

    password_reg pswd_reg( 
        .clk(clk),
        .identity(identity),
        .state(state),
        .edit_switch(edit_switch),
        .time_of_error(time_of_error),
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
    .finished     (finished)
   );
   

    /* state_indicate indicate(
        .state(state),
        .LEDs(LEDs)
    ); */

    

    always @(*) begin
        next_state = state0; // to avoid generating latch
        if (state0 == waiting && edit_switch == 1) begin 
            next_state = editing;
        end
        if (state0 == editing && finished == 1 )begin // 10s no operation,back to waiting
            next_state = waiting;
        end
        if (state0 == editing && check_result == 1) begin // when you entered the right password
            next_state = unlocked;
        end
        if (state0 == unlocked && finished == 1) begin // 20s no operation,back to waiting
            next_state = waiting;
        end
        if (state0 == editing && time_of_error == 2'd3) begin // when you entered wrong password 3 times
            next_state = alarming;
        end
        if (state0 == alarming && admin_button == 0) begin
            next_state = waiting;
        end
        if (state0 == unlocked && ok_signal == 0) begin
            next_state = waiting;
        end
    end

    always @(posedge clk or negedge admin_button) begin
        if (admin_button == 0 && state0 == alarming) begin
            state0 <= waiting;
        end
        else begin
            state0 <= next_state;
        end
    end

    assign state_out = state0;
    

    
endmodule