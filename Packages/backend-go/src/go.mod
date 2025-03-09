module backend-go

go 1.24.1

//require dist v0.0.0
require golang.org/x/exp v0.0.0-20250305212735-054e65f0b394
require gonum.org/v1/gonum v0.15.1 // indireta, via "dist"

//replace dist v0.0.0 => ./src/dist