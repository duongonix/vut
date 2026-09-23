package main

import "fmt"

func main() {
	var total int64
	for i := int64(0); i < 100000; i++ {
		total += i
	}
	fmt.Println(total)
}
