# Python Based USB-SPI Communication To The Icestick Dev-Board 

Few of the FTDI pins are exposed to the FPGA chip. The exposed pins allow for 3 different slave SPI peripheral(within the FPGA). Because of how the FPGA and the FTDI chip happened to be connected, of how the FTDI chip is implemented and how the PyFTDI library is implemented, the communication through python to the icestick is (almost[^1]) seamless. The work is an adaptation of this blog post[^2].


[^1]: Slave 0 cannot be used, because its CS from the FTDI is not connected to the FPGA.  
[^2]: https://blog.julian1.io/2017/01/29/icestick-ftdi-spi.html

## Running The Example

```bash
uv run apio upload # Upload the project to the icestick while ensuring dependencies are installed through UV
uv run main.py # Communicate with the FPGA through the script
```

## What Should You See?

The script should output the following:
```
=== Testing Slave1 ===
Echo
Ping
Pong

=== Testing Slave2 ===
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello World!
Hello Wor

=== Testing Slave3 ===
```
Further, you should see a small light show from the icestick leds (done by Slave3). This showcases the functioning of the 3 spi slaves implemented within [top.sv](./top.sv) (`slave1`, `slave2` and `slave3`).
