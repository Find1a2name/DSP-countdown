module cutdown(clkin,clk_dvd,ke,ku,kd,kl,kr,sel1,sel2,sel3,sel4,sel5,sel6,led,alarm);
input clkin,ke,ku,kd,kl,kr;
output clk_dvd;
reg [31:0]cnt=0;
reg clk_dvd;
reg rst_n = 1'b1;
output reg sel1,sel2,sel3,sel4,sel5,sel6;
reg [2:0] sel= 1;
reg [23:0]data = 24'h523456;
reg [23:0] dat;reg [23:0] t = 24'hAAAAAA;reg [4:0] js;

reg ss = 0;
	
reg [3:0]num;	//数码管显示数the num the led display
output reg [7:0]led;//数码管LED八级

reg [1:0]state=0;
	
reg [31:0] fd;reg [31:0] fd1;reg [31:0] fd2;reg [31:0] fd3;reg [31:0] fd4;reg [31:0] fd5;//防抖计数器，牺牲了很大的内存，...
	//...有一种好的改进方法是每隔20ms传输一次数据，或者直接在回跳的抖动时间内也重新置零；
reg [2:0] sell = 1;
reg [30:0] ds1;
reg wwait = 1;reg wwait1,wwait2,wwait3,wwait4,wwait5;
output reg alarm = 1;
	
//分频
always@(posedge clkin)
begin
	if	(cnt==1000000)
	begin
		clk_dvd=~clk_dvd;
		cnt = 0;
	end
	else
	cnt <= cnt+1;
end
//选择哪个亮
always @(posedge clk_dvd)
begin
	if(sel==3'h6)
		sel <= 1;
	else
	begin
		sel <= sel+1;
	end
	
case(sel)
	3'd1:	begin sel1<=0;sel2<=1;sel3<=1;sel4<=1;sel5<=1;sel6<=1;end
	3'd2:	begin sel2<=0;sel1<=1;sel3<=1;sel4<=1;sel5<=1;sel6<=1;end
	3'd3:	begin sel3<=0;sel2<=1;sel1<=1;sel4<=1;sel5<=1;sel6<=1;end
	3'd4:	begin sel4<=0;sel2<=1;sel3<=1;sel1<=1;sel5<=1;sel6<=1;end
	3'd5:	begin sel5<=0;sel2<=1;sel3<=1;sel4<=1;sel1<=1;sel6<=1;end
	3'd6:	begin sel6<=0;sel2<=1;sel3<=1;sel4<=1;sel5<=1;sel1<=1;end
endcase
end
//选择数字
always @(sel)
begin
	if (sell == sel)
		if(js <= 5)
			js = js+1;
			ss = 0;
		else
		begin
			if(js == 6)
			begin
				js = js+1;
				ss = 1;
			end
			else
			begin
				js = 0;
				ss = 1;
			end
				
		end
	else 
		ss = 0;
	
if(ss==0)
	case(sel)
	3'h1: num = data[23:20];
	3'h2: num = data[19:16];
	3'h3: num = data[15:12];
	3'h4: num = data[11:8];
	3'h5: num = data[7:4];
	3'h6: num = data[3:0];
	endcase
else
	num = 4'hA;
end
	
	
always @(posedge clk_dvd)
begin
	
case(num)
	
	4'h0: led = 8'hC0;
	4'h1: led = 8'hF9;
	4'h2: led = 8'hA4;
	4'h3: led = 8'hB0;
	4'h4: led = 8'h99;
	4'h5: led = 8'h92;
	4'h6: led = 8'h82;
	4'h7: led = 8'hF8;
	4'h8: led = 8'h80;
	4'h9: led = 8'h90;
	4'hA: led = 8'hFF;
	4'hB: led = 8'h86;
	4'hC: led = 8'hAB;
	4'hD: led = 8'hA1;
endcase
end

always @(posedge clkin)
begin

	case(state)
	2'h0:begin
	ds1 <= 0;
	data <= 24'h123456;
	if ((ke==0) || (fd>0))
	begin
		if(fd<1000000)
		fd <= fd+1;
		else
		begin
			if(ke==0)
				wwait <= 0;
			else
				if(wwait==0)
				begin
				wwait <= 1;
				wwait1 <= 1;wwait2 <= 1;wwait3 <= 1;wwait4 <= 1;wwait5 <= 1;
				state <= 2'h1;
				fd <= 0;
				fd1<=0;
				fd2<=0;
				fd3<=0;fd4<=0;fd5<=0;
				sell <= 6;
				data <=24'h0;
				end
		end
	end
end

2'h1:begin
		
		
	if ((ku==0) || (fd1>0))
	begin
		if((fd1<1000000))
			fd1 <= fd1+1;
		else
		begin
			if(ku==0)
			
			wwait1 <= 0;
			else
			begin
				if(wwait1==0)
				begin
					case(sell)
					1:begin if(data[23:20] == 9) data[23:20]<=0;else data[23:20]<=data[23:20]+4'b1;end
					2:begin if(data[19:16] == 9) data[19:16]<=0;else data[19:16]<=data[19:16]+4'b1;end
					3:begin if(data[15:12] == 9) data[15:12]<=0;else data[15:12]<=data[15:12]+4'b1;end
					4:begin if(data[11:8] == 9) data[11:8]<=0;else data[11:8]<=data[11:8]+4'b1;end
					5:begin if(data[7:4] == 9) data[7:4]<=0;else data[7:4]<=data[7:4]+4'b1;end
					6:begin if(data[3:0] == 9) data[3:0]<=0;else data[3:0]<=data[3:0]+4'b1;end
					endcase
					wwait1 <= 1;
					fd1 <= 0;
				end
			end
		end
	end
	
if ((kd==0) || (fd2>0))
begin
	if (fd2<1000000)
		fd2 <= fd2+1;
	else
	begin
		if(kd == 0)
			wwait2 <= 0;
		else
		begin
			if(wwait2==0)
			begin
			case(sell)
			1:begin if(data[23:20] == 0) data[23:20]<=9;else data[23:20]<=data[23:20]-4'b1;end
			2:begin if(data[19:16] == 0) data[19:16]<=9;else data[19:16]<=data[19:16]-4'b1;end
			3:begin if(data[15:12] == 0) data[15:12]<=9;else data[15:12]<=data[15:12]-4'b1;end
			4:begin if(data[11:8] == 0) data[11:8]<=9;else data[11:8]<=data[11:8]-4'b1;end
			5:begin if(data[7:4] == 0) data[7:4]<=9;else data[7:4]<=data[7:4]-4'b1;end
			6:begin if(data[3:0] == 0) data[3:0]<=9;else data[3:0]<=data[3:0]-4'b1;end
			endcase
			wwait2 <= 1;
			fd2 <= 0;
			end
		end
	end
end

if ((kr==0) || (fd3>0))
begin
	if(fd3<1000000)
	fd3 <= fd3+1;
	else
	begin
		if(kr==0)
		wwait3 <= 0;
		else
			if(wwait3 == 0)
			begin
				if (sell==6)
					sell <= 1;
				else
					sell<=sell+1'b1;
				fd3 <= 0;
				wwait3 <= 1;
			end
	end
end

if ((kl==0) || (fd4>0))
begin
	if(fd4<1000000)
		fd4 <= fd4+1;
	else
	begin
		if(kl==0)
			wwait4 <= 0;
		else
			if(wwait4 == 0)
			begin
				if (sell==1)
					sell <= 6;
				else
					sell<=sell-1'b1;
				fd4 <= 0;
				wwait4 <= 1;
			end
	end
end

if ((ke==0) || (fd5>0))
begin
	if(fd5<1000000)
		fd5 <= fd5+1;
	else
	begin
		if(ke==0)
			wwait5 <= 0;
		else
			if(wwait5==0)
			begin
				wwait5 <= 1;
				state <= 2'h2;
				fd5 <= 0;
			end
	end
end

end

2'd2:begin
if ((ke==0) || (fd>0))
	begin
	
	if(fd<1000000)
		fd <= fd+1;
	else
	begin
		if(ke==0)
		wwait <= 0;
		else
			if(wwait==0)
			begin
				wwait <= 1;
				state <= 2'h3;
				fd <= 0;
			end
	end	
end

if (ds1<50000000)
	ds1<=ds1+1;
else
begin
	ds1 <= 0;
	if (data[3:0]>0)
		data[3:0] <= data[3:0]-1;
	else
	begin
		if(data[23:4]>0)
		begin
			data[3:0] <= 4'h9;
			if(data[7:4]>0)
				data[7:4] <= data[7:4]-1;
			else
			begin
				data[7:4] <= 4'h9;
				if(data[11:8]>0)
					data[11:8] <= data[11:8]-1;
				else
				begin
					data[11:8] <= 4'h9;
					if(data[15:12]>0)
						data[15:12] <= data[15:12]-1;
					else
					begin
						data[15:12] <= 4'h9;
						if(data[19:16]>0)
							data[19:16] <= data[19:16]-1;
						else
						begin
							data[19:16] <= 4'h9;
							data[23:20] <= data[23:20]-1;
						end
					end
				end
			end
		end
		else
			state <= 2'h3;
	end
end

end

2'd3:
begin
	data <= 24'hAABCDA;
	alarm <= 0;
	if ((ke==0) || (fd>0))
		begin
		if(fd<1000000)
			fd <= fd+1;
		else
		begin
			if(ke==0)
				wwait <= 0;
			else
				if(wwait==0)
				begin
					wwait <= 1;
					state <= 2'h0;
					fd <= 0;
					alarm <= 1;
				end
		end
		end
end
endcase
end
endmodule
