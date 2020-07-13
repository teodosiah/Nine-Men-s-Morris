
class Board {
    let SIZE: Int = 7    
    var board  = [[String]]()
    init() {
        self.board = Array(repeating: Array(repeating: "", count: SIZE), count: SIZE)        
		for i in 0...6{           
           if i == 0 || i == 6{
              self.board[i] = ["free", "invalid", "invalid", "free", "invalid", "invalid", "free"]
           } 
           if i == 1 || i == 5{
              self.board[i] = ["invalid", "free", "invalid", "free", "invalid", "free", "invalid"]
           } 
           if i == 2 || i == 4{
              self.board[i] = ["invalid", "invalid", "free", "free", "free", "invalid", "invalid"]
           } 
           if i == 3{
               self.board[i] = ["free", "free", "free", "invalid", "free", "free", "free"]
           }       
        }
	} 
    func elemOnIndex(col: String, row: Int) -> String{
        let colId : Int = Int((col.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value) 
        return self.board[row][colId]
    }
    func isValidPosition(pos: String) -> Bool{
           let row: Int = Int(String(pos.last!))! - 1
           let col: String = String(pos.first!)
           
           if row < 0 || row > 6 || col < "A" || col > "G"{
               return false
           }
           return true
    }
    func hasValidNeighbour(row: Int, col: Int, player: String, neighbour: String) -> (Int, Int){  
        switch neighbour{
            case "left": return hasLeftNeighbour(row: row, col: col, player: player)                                
            case "right": return hasRightNeighbour(row: row, col: col, player: player) 
            case "up": return hasUpNeighbour(row: row, col: col, player: player)
            case "down": return hasDownNeighbour(row: row, col: col, player: player) 
            case "up-left": return hasUpLeftNeighbour(row: row, col: col, player: player)
            case "up-right": return hasUpRightNeighbour(row: row, col: col, player: player) 
            case "down-left": return hasDownLeftNeighbour(row: row, col: col, player: player)
            case "down-right": return hasDownRightNeighbour(row: row, col: col, player: player)
            default: return (-1, -1)
        }        
    }
    func hasRightNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the last column
        if row >= 0 && row < 7 && col >= 0 && col < 6{
           let nextCol: Int = col + 1
           for i in nextCol...6{
               if self.board[row][i] != "invalid" {
                   if self.board[row][i] == player{
                      return (row, i)
                   }else{
                       break
                   }                
               }
           }
        }
        return (-1, -1)  // no valid right neighbour
    }
     func hasLeftNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the first column        
        if row >= 0 && row < 7 && col >= 0 && col < 7{
           let prevCol: Int = col - 1
           if(prevCol < 0){
            return (-1, -1)
           }
           for i in stride(from: prevCol, to: -1, by: -1){                            
               if self.board[row][i] != "invalid" {                  
                   if self.board[row][i] == player{                                           
                      return (row, i)
                   }
                   else{
                       break
                   }  
                }                                
            }
         }        
        return (-1, -1) // no valid left neighbour
    }
     func hasUpNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the first row
        if row >= 0 && row < 7 && col >= 0 && col <= 6{
           let prevRow: Int = row - 1
            if(prevRow < 0){
            return (-1, -1)
           }
           for i in stride(from: prevRow, to: -1, by: -1){
               if self.board[i][col] != "invalid" {
                   if self.board[i][col] == player{
                      return (i, col)
                   }else{
                       break
                   }                  
               }
           }
        }
        return (-1, -1)  // no valid left neighbour
    }
    func hasDownNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the last row
        if row >= 0 && row < 6 && col >= 0 && col <= 6{
           let nextRow: Int = row + 1
           for i in nextRow...6{
               if self.board[i][col] != "invalid" {
                   if self.board[i][col] == player{
                      return (i, col)
                   }else{
                       break
                   }                  
               }
           }
        }
        return (-1, -1) // no valid left neighbour
    }
    func hasUpRightNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the first row or in the last column
        if row >= 0 && row < 7 && col >= 0 && col < 6{
           var prevRow: Int = row - 1
            if(prevRow < 0){
              return (-1, -1)
           }
           var nextCol: Int = col + 1
           if prevRow == 3 && nextCol == 3{
               prevRow = 2
               nextCol = 4
           }
           
           if self.board[prevRow][nextCol] == player{
              return (prevRow, nextCol)                                   
           } 
        }
        return (-1, -1)  // no valid up-right neighbour
    }
     func hasUpLeftNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the first row or in the first column
        if row >= 0 && row < 7 && col > 0 && col <= 6{
           var prevRow: Int = row - 1
            if(prevRow < 0){
              return (-1, -1)
           }
           var prevCol: Int = col - 1
           if prevRow == 3 && prevCol == 3{
               prevRow = 2
               prevCol = 2
           }
           
           if self.board[prevRow][prevCol] == player{
              return (prevRow, prevCol)                                
           } 
        }
        return (-1, -1)  // no valid up-left neighbour
    }
    func hasDownRightNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the last row or in the last column
        if row >= 0 && row < 6 && col >= 0 && col < 6{
           var nextRow: Int = row + 1
           var nextCol: Int = col + 1
           if nextRow == 3 && nextCol == 3{
               nextRow = 4
               nextCol = 4
           }
           
           if self.board[nextRow][nextCol] == player{
              return (nextRow, nextCol)                                   
           }           
        }
        return (-1, -1)  // no valid down-right neighbour
    }
    func hasDownLeftNeighbour(row: Int, col: Int, player: String) -> (Int, Int){
        //if the position is valid an is not in the last row or in the first column
        if row >= 0 && row < 6 && col >= 0 && col <= 6{
           var nextRow: Int = row + 1
           var prevCol: Int = col - 1
            if(prevCol < 0){
              return (-1, -1)
           }
           if nextRow == 3 && prevCol == 3{
               nextRow = 4
               prevCol = 2
           }
           
           if self.board[nextRow][prevCol] == player{
              return (nextRow, prevCol)                                
           }           
        }
        return (-1, -1) // no valid down-left neighbour
    }
    //determine the correct character on positions where cannot be piece
    func nonPiecePosition(col: Int, row: Int) -> String{
        if col == 0 || col == 6{
            return "-"
        }
        if row == 0 || row == 6{
            return "|"
        }
        if col == 1 || col == 5{
            return "-"
        }
        if (row == 1 || row == 5) && (col == 2 || col == 4){
            return "|"
        }
        if col == 3 && row == 3{
            return " "
        }
        if col != 3{
            return "-"
        }
        return ""
    }
    func positionToString(col: Int, row: Int) -> String{
        switch board[col][row] {
        case "free": return "."
        case "invalid": let pos = nonPiecePosition(col: col, row: row)
                        return pos            
        default: return board[col][row]            
        }
    }
    func printBoard(){
        print("   A   B   C   D   E   F   G")
        for i in 0...6{
            print("\(i + 1)  ", terminator:"")
            for j in 0...6{
                let boardval = positionToString(col: i, row: j)
                print("\(boardval)", terminator:"")
                if i == 0 || i == 6{                   
                    if j != 6{
                       print("---", terminator:"")
                    }                 
                }
                if i == 1 || i == 5{
                    if j == 0 || j == 5{
                        print("   ", terminator:"")
                    }else{
                        if j != 6{
                           print("---", terminator:"")
                        }
                    }
                }
                if i == 2 || i == 4{
                   if j == 2 || j == 3{
                        print("---", terminator:"")
                    }else{
                        print("   ", terminator:"")
                    }
                }
                if i == 3{
                 if j == 2 || j == 3{
                        print("   ", terminator:"")
                    }else{
                        if j != 6{
                           print("---", terminator:"")
                        }
                    }
                }               
            }
            print("\n")
            if i == 0 || i == 5{
                print("   |           |           |", terminator:"")
            }else if i == 1 || i == 4{
                print("   |   |       |       |   |", terminator:"")
            }else if i != 6{
                print("   |   |   |       |   |   |", terminator:"")
            }
            print("\n")
        }
    }
    func getPosString(col: String, row: Int) -> String{
        if (col >= "A" && col < "G") && (row >= 0 && row < 7){
            let colId : Int = Int((col.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value)            
            return self.board[colId][row]
        }
        //error - no such index at the board
        return "-1"
    }
    func setPosition(col: String, row: Int, player: String) -> Int{       
        if (col >= "A" && col <= "G") && (row >= 0 && row < 7){
            let colId : Int = Int((col.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value)                      
            let requiredPosition = self.board[row][colId]
            if requiredPosition != "invalid"{
                self.board[row][colId] = player
                //success
                return 0
            }
        }
        //error
        return -1        
    }
}