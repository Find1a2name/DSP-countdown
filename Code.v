
//https://wenku.baidu.com/view/c2a4d314336c1eb91b375d28.html?from=search###
//this work is where i find spirit;

Module countdown (clk,clk_dvd,ke,ku,kd,kl,kr,sel,data,num,cnt,rst_n,);
	input clk,ke,ku,kd,kl,kr;
	
	reg [18:0]cnt;
	reg clk_dvd;
	reg rst_n = 1b’1;
	
	output sel;
	reg [2:0] sel = 1;

	reg [23:0]data = 24‘h001234;//需要修改
	reg [3:0]num;

//分频
	always@(posedge clk or negedge rst_n)
	begin
		if(~rst_n)
			begin
				cnt <= 0;
				rst_n <= 1;
			end
		else
			begin
				cnt <= cnt+1’b1;
				clk_devide <= cnt[16];
			end
		if(cnt[18:16] == 3b’110)
			rst_n <= 0;
	end

//选择哪个亮
	always @(posedge clk_dvd or negedge rst_n)
	begin
		if(~rst_n)
			sel <= 1;
		else 
			begin
				sel <= sel+1’b1;
			end
	end

//选择数字
	always @(sel)
	begin
		case(sel)
		3’h1: num = data[23:20];
		3’h2: num = data[19:16];
		3’h3: num = data[15:12];
		3’h4: num = data[11:8];
		3’h5: num = data[7:4];
		3’h6: num = data[3:0];
		endcase
	end

	always @(posedge clk_dvd or negedge rst_n)
	begin
		case(num)
			4’h0: led = 8’hC0;
			4’h1: led = 8’hF9;
			4’h2: led = 8’hA4;
			4’h3: led = 8’hB0;
			4’h4: led = 8’h99;
			4’h5: led = 8’h92;
			4’h6: led = 8’h82;
			4’h7: led = 8’hF8;
			4’h8: led = 8’h80;
			4’h9: led = 8’h90;
		endcase
	end

endmodule





			
				

	
