# AmericanRoulette

![image](https://user-images.githubusercontent.com/77036003/146883245-369dea31-cea2-476a-927c-cff05c43527a.png)

Every time you execute the (getRandomNumber) function, you will recieve a random number (Chainlink's VRF is used) and execute the function you choose and if the random number matches your chosen number you will win.

You can't choose the number 0, if the random number you received is 0, then you will lose 

There are several bets like:
- You can bet on any single number from 1 to 36, if you win, you will recieve {(the number you selected)/2 * (your bet amount)} amount of money 
- You can bet on either black or red, odd or even, high or low. You wil recieve 2x the amount you bet if you win
- You can bet on columns or in dozens and you will recieve 3x the amount you bet if you win

Every way of bet is written as seperate function since it will reduce the gas price to execute the function
