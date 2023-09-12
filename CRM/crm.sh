#!/bin/bash

echo --- Set CRM functions ---

# -----------------------------------------------------------
# Functions
# -----------------------------------------------------------

ccrm()
{
  cd $U01/CRM/bin
  killall CRM
}

ctma()
{
  cd $U01/SNA122264/tma_sna
}

csnas()
{
 cd $U01/snas
 . env.sh
 ./stop.sh
}
