#!/bin/bash

echo -n "Enter a integer: "
read num1

echo -n "Enter another integer: "
read num2

sum=$(($num1+$num2))
product=$(($num1*$num2))

echo "The sum of $num1 and $num2 is $sum"
echo "The product of $num1 and $num2 is $product"

if [$sum -lt $product]
then
    echo "The sum is less than the product."
elif [$sum == $product]
    echo "The sum is equal to the product"
elif [$sum -gt $product]
    echo "The sum is greater than the product."
fi