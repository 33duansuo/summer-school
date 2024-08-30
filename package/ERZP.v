module ERZP (CLK, KIN,KOUT);
    input CLK, KIN; //工作时钟和输入信�??
    output KOUT; reg KOUT;
    reg [3:0] KH,KL; //定义对高电平和低电平脉宽计数之寄存器
    always @(posedge CLK) begin
        if (!KIN) KL<=KL+1 ; //对键输入的低电平脉宽计数
        else KL<=4'b0000; end //若出现高电平, 则计数器清零
    always @(posedge CLK) begin
        if (KIN) KH<= KH+1; //同时对键输入的高电平脉宽计数
        else KH<=4'b0000; end //若出现高电平, 则计数器清零
    always @(posedge CLK) begin 
        if (KH > 4'b1100) KOUT<=1'B1;//对高电平脉宽计数�??旦大�??12, 则输�??1 
        else if (KL > 4'b0111) KOUT<=1'B0; //对低电平脉宽计数若大�??7, 则输�??0
    end
endmodule