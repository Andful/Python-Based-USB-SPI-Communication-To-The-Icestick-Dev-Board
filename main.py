from pyftdi.spi import SpiController
from time import sleep

spi = SpiController(cs_count=4)

spi.configure("ftdi://ftdi:2232h/2")

slave1 = spi.get_port(cs=1, freq=12E6, mode=0)
slave2 = spi.get_port(cs=2, freq=12E6, mode=0)
slave3 = spi.get_port(cs=3, freq=12E6, mode=0)

result = slave1.exchange(b"Echo", duplex=True)
print(result.decode())
result = slave1.exchange(b"Ping", duplex=True)
print(result.decode())
result = slave1.exchange(b"Pong", duplex=True)
print(result.decode())

result = slave2.exchange([0xff]*100, duplex=True)

print(result.decode())

for _ in range(3):
    slave3.exchange([0x02], duplex=True)
    sleep(1)
    slave3.exchange([0x04], duplex=True)
    sleep(1)
    slave3.exchange([0x08], duplex=True)
    sleep(1)
    slave3.exchange([0x10], duplex=True)
    sleep(1)

slave3.exchange([0x01], duplex=True)
sleep(1)

spi.close()