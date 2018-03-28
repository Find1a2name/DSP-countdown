module djs(clkin,clk_dvd,ke,ku,kd,kl,kr,sel1,sel2,sel3,sel4,sel5,sel6,led,alarm);
	input clkin,ke,ku,kd,kl,kr;
	output clk_dvd;
	reg [31:0]cnt=0;
	reg clk_dvd;
	reg rst_n = 1'b1;
	output reg sel1,sel2,sel3,sel4,sel5,sel6;
	reg [2:0] sel= 1;
	reg [23:0]data = 24'h523456;//需要修改
	reg [3:0]num;
	output reg [7:0]led;
	
	reg [1:0]state=0;
	reg [31:0] fd;
	reg [2:0] sell = 1;
	reg [30:0] ds1;
	reg wwait = 1;
	input reg alarm;
	
	
//分频
always@(posedge clkin)
begin
	
	if	(cnt==100000)
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
	case(sel)
		3'h1: num = data[23:20];
		3'h2: num = data[19:16];
		3'h3: num = data[15:12];
		3'h4: num = data[11:8];
		3'h5: num = data[7:4];
		3'h6: num = data[3:0];
	endcase
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
		4'hB: led = 8'h83;
		4'hC: led = 8'h61;
		4'hD: led = 8'h11;
	endcase
	end

// always @(posedge clk_dvd)
// begin
	
	
// 	if (ds1<50000000)
// 		ds1<=ds1+1;
// 	else
// 	begin
// 		if (data[3:0]>0)
// 			data[3:0] <= data[3:0]-1;		
// 		else
// 		begin
// 			if(data[23:4]>0)
// 			begin
// 				data[3:0] <= 4'h9;
// 				if(data[7:4]>0)
// 					data[7:4] <= data[7:4]-1;
// 				else
// 				begin
// 					data[7:4] <= 4'h9;
// 					if(data[11:8]>0)
// 						data[11:8] <= data[11:8]-1;
// 					else
// 					begin
// 						data[11:8] <= 4'h9;
// 						if(data[15:12]>0)
// 							data[15:12] <= data[15:12]-1;
// 						else
// 						begin
// 							data[15:12] <= 4'h9;
// 							if(data[19:16]>0)
// 								data[19:16] <= data[19:16]-1;
// 							else
// 							begin
// 								data[19:16] <= 4'h9;
// 								data[23:20] <= data[23:20]-1;
// 							end
// 						end
// 					end
// 				end		
// 			end
// 			else 
// 				state <= 2'h3
// 		   end		
// 	ds1 <= 0;
			
// 	end

// end
	
	
	
	
always @(posedge clkin)
	begin
//	state <= 2'd2;
	case(state)
		
			2'h0:begin
					
				ds1 <= 0;
				data <= 0;
				
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
								state <= 2'h1;
								fd <= 0;
								
							end
								
					end	
				end
					
			end
		
		2'h1:begin
			//data <=24'h2301;
			
			if ((ku==0) || fd)
			begin
				if((fd<1000000))
					fd <= fd+1;
				else
				begin
					if(ku==0)
						wwait <= 0;
					else
					begin
						if(wwait==0)
						begin
							
						case(sell)
						1:data[23:20]<=data[23:20]+4'b1;
						2:data[19:16]<=data[19:16]+1;
						3:data[15:12]<=data[15:12]+1;
						4:data[11:8]<=data[11:8]+1;
						5:data[7:4]<=data[7:4]+1;
						6:data[3:0]<=data[3:0]+1;
						endcase
							
						wwait <= 1;
						fd <= 0;
						end
					end
				end
			end
				
			if ((kd==0) || fd)
			begin
				if (fd<1000000)
					fd <= fd+1;
				else
				begin
					if(kd == 0)
						wwait <= 0;
					else
					begin
						if(wwait==0)
						begin
						case(sell)
						1:data[23:20]<=data[23:20]-1;
						2:data[19:16]<=data[19:16]-1;
						3:data[15:12]<=data[15:12]-1;
						4:data[11:8]<=data[11:8]-1;
						5:data[7:4]<=data[7:4]-1;
						6:data[3:0]<=data[3:0]-1;
						endcase
						wwait <= 1;
						fd <= 0;
						end
					end
					
				end
			end
			
			
			
				
				
				
			if ((kr==0) || fd)
			begin
				if(fd<1000000)
					fd <= fd+1;
				else
				begin
					if(kr==0)
						wwait <= 0;
					else
						if(wwait == 0)
						begin
					
							if (sell==6)
								sell <= 1;
							else
								sell<=sell+1;
							fd <= 0;
							wwait <= 1;
						end	
				
			end	
				
				
			if ((kl==0) || fd)
			begin
				if(fd<1000000)
					fd <= fd+1;
				else
				begin
					if(kl==0)
						wwait <= 0;
					else
						if(wwait == 0)
						begin
					
							if (sell==1)
								sell <= 6;
							else
								sell<=sell-1;
							fd <= 0;
							wwait <= 1;
						end	
				
			end	
			
	
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
							state <= 2'h2;
							fd <= 0;
								
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
				state <= 2'h3
		   end		
	
				
		end
	end
		
	2'd3:
	begin
		
		data <= 24'hA0BCDA;
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
