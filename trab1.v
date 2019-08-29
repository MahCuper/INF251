module altonivel ( input [7:0] a, input [7:0] b, output M,I);
assign M = a > b;
assign I = a == b;
endmodule 

module MaiorIgual2Bits(input[1:0]a,input[1:0]b,output M,output I);
    assign M =(a[0] & ~b[1] & ~b[0]) | (a[1] & a[0] & ~b[0]) | (a[1] & ~b[1]);
    assign I =(~a[1] & ~a[0] & ~b[1] & ~b[0]) | (a[1] & ~a[0] & b[1] & ~b[0]) | (~a[1] & a[0] & ~b[1] & b[0]) | (a[1] & a[0] & b[1] & b[0]);
endmodule

module MaiorIgualArvore(input Me,input Ie,input Md,input Id, output M, output I);
    assign M = (Ie & Md) | (Me);
    assign I = (Ie & Id);
endmodule

module Arvore(input[7:0]a, input[7:0] b, output M, output I);
    wire m76,i76,m54,i54,m32,i32,m10,i10, me,ie,md,id;
    MaiorIgual2Bits M76(a[7:6],b[7:6],m76,i76);
    MaiorIgual2Bits M54(a[5:4],b[5:4],m54,i54);
    MaiorIgual2Bits M32(a[3:2],b[3:2],m32,i32);
    MaiorIgual2Bits M10(a[1:0],b[1:0],m10,i10);
  
    MaiorIgualArvore A1(m76,i76,m54,i54,me,ie);
    MaiorIgualArvore A2(m32,i32,m10,i10,md,id);
    MaiorIgualArvore A3(me,ie,md,id,M,I);
endmodule

module stimulus;
    reg [7:0] a,b;
    wire m1,m2,i1,i2;
    altonivel M1(a,b,m1,i1);
    Arvore   M2(a,b,m2,i2);
    integer i;     
    initial begin
                
    $monitor(" a=%d,b=%d A>B %b%b A==B %b%b",a,b,m1,m2,i1,i2);
      for (i=0; i < (256*256); i=i+1)
	begin 
          a= i[15:8]; b = i[7:0]; #1;
	  if ( m1 !== m2 || i1 !== i2 ) $display("Falha ! a=%d b=%d maior %b %b igual %b %b",a,b,m1,m2,i1,i2);
       	end   
    end  
     
    endmodule
