# USRP "Airdrop"
Olin College FA19 Analog and Digital Communications Final Project completed by [Samantha Young](https://github.com/SamYoung20), [Vivien Chen](https://github.com/vivienyuwenchen), [Lauren Anfenson](https://github.com/lanfenson), and [Anusha Datar](https://github.com/anushadatar). 
## Summary
In this final project we send images wirelessly between two USRP B210 software defined radios. We first use Lempel-Ziv-Welch (LZW) compression, a popular source coding technique, to compress the image file. We then modulate the compressed signal using  Quadrature Phase Shift Keying (QPSK), or 4-bit QAM. We transmit this information with one radio, receive it with another radio, and then correct for errors and decode the values in the received signal. This combination of compressing the image and using QPSK increases the data rate and reduces the time needed to send and receive the signal.

This repository includes the code associated with this process, with [transmit_image](https://github.com/anushadatar/USRP-airdrop/blob/master/transmit_image.m) calling the necesssary functions to prepare a file to transmit and [receive_data](https://github.com/anushadatar/USRP-airdrop/blob/master/receive_data.m) to process a received file. 

For more information, check out our [final report TODO UPLOAD TO GH AND ADD LINK]() and [presentation](https://docs.google.com/presentation/d/1z7SVGgXfu3hnzfCLlbkORCMY87OU6EDbpJtw_uwTl6o/edit?usp=sharing).
