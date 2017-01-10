This APB agent was from the Verification Academy Coverage Cookbook.

The APB driver has a bug if the PREADY is not asserted LOW during the ACCESS cycle.

The SPI and UART designs were converted from the Wishbone bus to the APB. A wait state is inserted by asserting the PREADY signal LOW.

However, this wait state is not strictly required in the APB specification.


