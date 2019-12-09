These instructions assume that you have two USRP B210 radios set up to interface with the UHD driver on Windows.

## Transmission
To send the image, run `transmit_image.m` with the file of the image. The script will create a compressed .dat file to transmit
using the B210 radio. 

To transmit the saved file across the channel, open up an administrative command prompt and type the following (substituting
the path to the transmit file following --file and the serial number of your radio following --args "serial") to navigate
to the appropriate directory and send over the file.
```bash
cd C:\Program Files\UHD\lib\uhd\examples>

tx_samples_from_file ‐‐freq 2478e6 ‐‐rate 2e6 ‐‐type float ‐‐args "serial=30CD3D7" ‐‐ant "TX/RX" ‐‐subdev "A:A" --gain 60 --file tx.dat
```

## Receipt
To receive the ddata from the transmitted file, open up an open up an administrative command prompt and type the following (substituting
the path to the location for the received file following --file and the serial number of your radio following --args "serial") to navigate
to the appropriate directory and send over the file.
```bash
cd C:\Program Files\UHD\lib\uhd\examples>

rx_samples_to_file ‐‐freq 2478e6 ‐‐rate 2e6 ‐‐type float ‐‐args "serial=30CF9A5" ‐‐ant "TX/RX" ‐‐subdev "A:A" --gain 40 --file rx.dat
```
Then, run the script `receive_image.m` on the data file to recover the original image.
