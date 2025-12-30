module slave1 (
    input logic clk,
    input logic en,
    input logic mosi,
    output logic miso
);
  assign miso = mosi;
endmodule

module slave2 (
    input logic clk,
    input logic en,
    input logic mosi,
    output logic miso
);
  localparam LENGTH = 13;
  logic  [LENGTH*8-1:0] 	message = "Hello World!\n";
  logic [15:0] counter = LENGTH*8 - 1;

  assign miso = message[counter];

  always_ff @(posedge clk) begin
    if (en) begin
      if ( counter == 0 ) begin
        counter <= LENGTH*8 - 1;
      end else begin
        counter <= counter - 1;
      end
    end
  end

endmodule

module slave3 (
    input logic clk,
    input logic en,
    input logic mosi,
    output logic miso,
    output logic [4:0] leds = 5'b0
);
  logic [6:0] data = 0;
  logic [3:0] counter = 7;

  assign miso = 0;
  always_ff @(posedge clk) begin
    if (en) begin
      if ( counter == 0 ) begin
        counter <= 7;
        leds <= {data, mosi};
      end else begin
        counter <= counter - 1;
        data[counter - 1] <= mosi;
      end
    end
  end
endmodule

module top (
    input logic clk,
    input logic cs1,
    input logic cs2,
    input logic cs3,
    output logic miso,
    input logic mosi,
    input logic sclk,
    output [4:0] leds
);
  logic miso1;
  logic miso2;
  logic miso3;

  slave1 i_slave1 (
    .clk(sclk),
    .en(~cs1),
    .mosi(mosi),
    .miso(miso1)
  );

  slave2 i_slave2 (
    .clk(sclk),
    .en(~cs2),
    .mosi(mosi),
    .miso(miso2)
  );

  slave3 i_slave3 (
    .clk(sclk),
    .en(~cs3),
    .mosi(mosi),
    .miso(miso3),
    .leds(leds)
  );

  always_comb begin
    miso = 0;
    casez ({cs1, cs2, cs3})
      3'b0zz : miso = miso1;
      3'bz0z : miso = miso2;
      3'bzz0 : miso = miso3;
    endcase
  end
endmodule
