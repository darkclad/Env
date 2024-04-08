#!/bin/bash

_stack_root=~/.stack

stack_create() {
  local _var=$1
  mkdir -p "$_stack_root/$_var"
}

stack_push() {
  local _var=$1
  shift
  if [ ! -d "$_stack_root/$_var" ]; then
    stack_create "$_var"
  fi
  local _size=$(stack_size "$_var")
  echo "$*" > "$_stack_root/$_var/i.$((++_size))"
}

stack_pick() {
  local _var=$1
  local _size=$(stack_size "$_var")
  if [ "$_size" = "0" ]; then
    echo ${!2}
    return
  fi
  cat "$_stack_root/$_var/i.$_size"
}

stack_pop() {
  stack_pick $*
  rm "$_stack_root/$1/i.$_size" 2>/dev/null
}

stack_size() {
  if [ ! -d "$_stack_root/$_var" ]; then
    echo 0
    return
  fi
  echo `ls -1 $_stack_root/$_var/ 2>/dev/null | wc -l`
}

stack_list() {
  ll $_stack_roor
}

stack_clear_all() {
  rm -rf $_stack_root
}
