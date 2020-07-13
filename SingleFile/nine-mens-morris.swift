class NineMensMorris{
    var board: Board
    var player1: Player
    var player2: Player

    init(){
        self.board = Board()
        self.player1 = Player(name: "x", symbol: "o")
        self.player2 = Player(name: "y", symbol: "x")
    }
    func Run(){
        //Phase 1: Placing pieces
        let first_part: Bool = firstPartGame()
        if first_part{
            endPrint()
            return
        }     
        //Phase 2 & Phase 3: Placing pieces until one of the players has 3 pieces (then "Flying") or until the game ends
        let second_part: Int = secondPartGame()
        if second_part == 0{
            endPrint()
            return
        }else{
            return
        }
    }
    //return true on win
    func firstPartGame() -> Bool{
        //each player has to position 9 pieces on the board so iter is form 1 to 9*2 - odd turns for o and even for x
        var iter: Int = 1     
        var printable: Bool = true   
        while iter <= 18 && 
             (self.player1.getPiecesOnBoardCount() + self.player1.getDeathPiecesCount() < 10 || 
              self.player2.getPiecesOnBoardCount() + self.player2.getDeathPiecesCount() < 10) {
            if printable{
              self.board.printBoard()
            }            
            var turn: String = ""
            if iter % 2 == 0{
               turn = "x"
            }else{
                turn = "o"
            }
            print("Player \(turn) put piece on position: ", terminator:"")
            if let pos1 = readLine(){
              if isInputValid(input: String(pos1), gamePart: 1){
                let pos_col: String = String(pos1.first!)
                let pos_row: Int = Int(String(pos1.last!))! - 1
                
                let success = self.board.setPosition(col: pos_col, row: pos_row, player: turn)
                if success == -1{
                    print("\nInvalid Position! Try again:")
                    printable = false
                    
                }else{
                    iter += 1
                    increasePiecesOfPlayer(player: turn)
                    printable = true
                    let colId : Int = Int((pos_col.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value)
                    //Check wheather the player has a Mill after set piece on position successfully
                    if isMill(row: pos_row, col: colId, player: turn){
                        self.board.printBoard()
                        let Mill_executed = onMill(player: turn) 
                        //GAME OVER
                        if Mill_executed{
                            return true
                        }                      
                    }
                } 
              }else{
                    print("\nInvalid Position! Try again:")
                    printable = false
              }  
            }            
        }
        return false
    }
    //return -1 - no winner, 0 - player with less than 3 pieces, 1 - player with no more moves
    func secondPartGame() -> Int{
       var iter: Int = 1
       var printable: Bool = true
       //would become 1 in case the player has 3 left pieces and could fly
       var player1_flag: Int = 0
       var player2_flag: Int = 0
       while true{           
           //check wheather players have 3 pieces on the board
           if self.player1.getPiecesOnBoardCount() == 3{
              player1_flag = 1
           }
           if self.player2.getPiecesOnBoardCount() == 3{
              player2_flag = 1
           }
           if printable{
              self.board.printBoard()
           }            
           var turn: String = ""
           var current_player_flag: Int = 0
           if iter % 2 == 0{
                turn = "x"
                current_player_flag = player2_flag                 
            }else{
                turn = "o"
                current_player_flag = player1_flag
            }
            if !canMoveSomePiece(player: turn){
                if turn == "x"{
                    print("Player x does not have any possible moves! Player o win!!!")                       
                }else{
                    print("Player o does not have any possible moves! Player x win!!!")
                }
                return 1
            }
            print("Player \(turn) move piece from position to position: ", terminator:"")
            if let position = readLine(){
                if isInputValid(input: position, gamePart: 2){
                    let from_pos: String = String(String(position).prefix(2))
                    let to_pos: String = String(String(position).suffix(2))                       
                       
                    //if this move is possible
                    if isPossibleMove(from: from_pos, to: to_pos, player: turn, flag: current_player_flag){                       
                        _ = self.board.setPosition(col: String(from_pos.first!), row: Int(String(from_pos.last!))! - 1, player: "free")
                        _ = self.board.setPosition(col: String(to_pos.first!), row: Int(String(to_pos.last!))! - 1, player: turn)

                        iter += 1
                        printable = true
                        let colId : Int = Int((String(to_pos.first!).unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value)
                        //Check wheather the player has a Mill after set piece on position successfully
                        if isMill(row: Int(String(to_pos.last!))! - 1, col: colId, player: turn){
                            self.board.printBoard()
                            let Mill_executed = onMill(player: turn) 
                            //GAME OVER
                            if Mill_executed{
                                return 0
                            }                      
                        }
                    }else{
                        printable = false
                        print("A piece may not 'jump' another piece!")                           
                    }
                }else{
                    print("\nInvalid Position! Try again:")
                    printable = false
                }  
            }          
       }
    }
  
    func endPrint(){
           if self.player2.getPiecesOnBoardCount() == 2{
             print("Player \(self.player1.getSymbolString()) WIN!!!!")
           }else if self.player1.getPiecesOnBoardCount() == 2{
             print("Player \(self.player2.getSymbolString()) WIN!!!!")
           }else{
             print("No winner!")
         }
    }
    func onMill(player: String) -> Bool{
        var isKilled: Bool = false                        
        while(!isKilled){
            print("You have a Mill!!! Kill oponent piece on position: ", terminator:"")
            if let killPos = readLine(){
                 if !isInputValid(input: String(killPos), gamePart: 1){
                    print("Enter Valid Position to Kill!")                    
                    continue
                }
                let kill_col: String = String(killPos.first!)
                let kill_row: Int = Int(String(killPos.last!))! - 1               
                if player == "o"{
                    if killOponentPiece(row: kill_row, col: kill_col, oponent: player2){
                        isKilled = true                                  
                    }
                }else{
                    if killOponentPiece(row: kill_row, col: kill_col, oponent: player1){
                        isKilled = true
                    }
                }                            
                if isGameOver(){
                    return true
                }
            }
        }
        return false
    }
    
    func isInputValid(input: String, gamePart: Int) -> Bool{
        var symCount: Int = 0
        if gamePart == 1{
            symCount = 2
        }else{
            symCount = 4
        }
        if input.count != symCount{
            return false
        } 
        if(symCount == 2){
           if !self.board.isValidPosition(pos: input){
               return false
           }
        }else{
            let from: String = String(String(input).prefix(2))
            let to: String = String(String(input).suffix(2)) 
            if !self.board.isValidPosition(pos: from) ||
               !self.board.isValidPosition(pos: to){
                   return false
            }
        }
        return true
    }
    func isMill(row: Int, col: Int, player: String) -> Bool{        
         if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "left")){
             let pos = self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "left")            
             if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "right")){
                 return true
             } 
             else if isValidPair(pair: self.board.hasValidNeighbour(row: pos.0, col: pos.1, player: player, neighbour: "left")){                 
                 return true
             }
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "right")){
              let pos = self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "right")
              if isValidPair(pair: self.board.hasValidNeighbour(row: pos.0, col: pos.1, player: player, neighbour: "right")){
                      return true
                  // already checked about left current right
              }                 
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "up")){
             let pos = self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "up")
             if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down")){
                 return true
             }
             else if isValidPair(pair: self.board.hasValidNeighbour(row: pos.0, col: pos.1, player: player, neighbour: "up")){
                 return true
             }
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down")){
               let pos = self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down")
                if isValidPair(pair: self.board.hasValidNeighbour(row: pos.0, col: pos.1, player: player, neighbour: "down")){
                      return true
                      // already checked about up current down
                }
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "up-left")){
             if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down-right")){
                 return true
             }else if isValidPair(pair: self.board.hasValidNeighbour(row: row - 1, col: col - 1, player: player, neighbour: "up-left")){
                 return true
             }
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "up-right")){
             if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down-left")){
                 return true
             }else if isValidPair(pair: self.board.hasValidNeighbour(row: row - 1, col: col + 1, player: player, neighbour: "up-right")){
                 return true
             }
         }
         else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down-left")) &&
                 isValidPair(pair: self.board.hasValidNeighbour(row: row + 1, col: col - 1, player: player, neighbour: "down-left")){
                 return true
                 // already checked about up-right current down-left
          } 
          else if isValidPair(pair: self.board.hasValidNeighbour(row: row, col: col, player: player, neighbour: "down-right")) &&
                  isValidPair(pair: self.board.hasValidNeighbour(row: row + 1, col: col + 1, player: player, neighbour: "down-right")){
                 return true
                 // already checked about up-left current down-right                  
         }       
        return false
    }
    func canMoveSomePiece(player: String) -> Bool{        
        for i in 0...6{
            for j in 0...6{
                let colChar: String = String(UnicodeScalar(UInt8(j + Int(("A".unicodeScalars.first)!.value))))
                 if self.board.elemOnIndex(col: colChar, row: i) == player{
                     if havePossibleMove(row: i, col: j){
                         return true
                     }
                 }
            }
        }
        return false
    }
    func havePossibleMove(row: Int, col: Int) -> Bool{
        if !isValidPair(pair: self.board.hasLeftNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasRightNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasUpNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasDownNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasUpLeftNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasUpRightNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasDownLeftNeighbour(row: row, col: col, player: "free")) &&
           !isValidPair(pair: self.board.hasDownRightNeighbour(row: row, col: col, player: "free")){
               return false
           } 
           return true
    }
    //Check whether such neighbour exist
    func isValidPair(pair: (Int, Int)) -> Bool{
        if pair.0 != -1 && pair.1 != -1{
            return true
        }
        return false
    }
    func increasePiecesOfPlayer(player: String){
        if player == "o"{
           self.player1.incrementPiecesOnBoardCount()
        }else{
           self.player2.incrementPiecesOnBoardCount()
        }
    }
    func isNextPosition(from: String, to: String) -> Bool{     
        let from_col: Int = Int(((from.first)!.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value) 
        let from_row: Int = Int(String(from.last!))! - 1
        let to_col: Int = Int(((to.first)!.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value) 
        let to_row: Int = Int(String(to.last!))! - 1
        //if possitions are valid
        if from_col < 0 || from_col > 6 ||
           from_row < 0 || from_row > 6 ||
           to_row < 0 || to_row > 6{
               return false
           }        
        //on the same row - left or right move
        if from_row == to_row && from_col != to_col{
            //next to each other
           if from_col == to_col + 1 || from_col == to_col - 1{          
              if self.board.elemOnIndex(col: String(to.first!), row: from_row) != "free"{
                 return false
              }
           }else{
              let maxCol: Int = max(from_col, to_col) - 1
              let minCol: Int = min(from_col, to_col) + 1  
              for i in minCol...maxCol{
                 let colChar: String = String(UnicodeScalar(UInt8(i + Int(("A".unicodeScalars.first)!.value))))
                 if self.board.elemOnIndex(col: colChar, row: from_row) != "invalid" {
                   return false
                 }else{
                   let evalPos: String = self.board.nonPiecePosition(col: i, row: from_row)
                    if evalPos != "|" && evalPos != "-"{
                       return false
                    }
                 }
              }
           }
        }
        //on the same col - up or down
         if from_row != to_row && from_col == to_col{
            //next to each other
            if from_row == to_row + 1 || from_row == to_row - 1{   
                if self.board.elemOnIndex(col: String(to.first!), row: to_row) != "free"{
                 return false
             }
           }else{
              let maxRow: Int = max(from_row, to_row) - 1
              let minRow: Int = min(from_row, to_row) + 1
              for i in minRow...maxRow{              
               if self.board.elemOnIndex(col: String(from.first!), row: i) != "invalid" {
                   return false
               }else{                    
                    let evalPos: String = self.board.nonPiecePosition(col: from_col, row: i)
                    if evalPos != "|" && evalPos != "-"{
                       return false
                    }
               }
            }
           }           
        }
        //pos different from up and down/ left and right
        if from_row != to_row && from_col != to_col{
            return false
        }        
        return true;
    }   
    //flag indicates wheather the player can 'fly' i.e. he has 3 pieces left --> 0 if he have more than 3 and 1 if he could fly    
    func isPossibleMove(from: String, to: String, player: String, flag: Int) -> Bool{
        //from should have value as the player men
        //to has to be next position and to be free   
        if flag == 0{
            if self.board.elemOnIndex(col: String(from.first!), row: Int(String(from.last!))! - 1) == player{
            if self.board.elemOnIndex(col: String(to.first!), row: Int(String(to.last!))! - 1) == "free" 
              && isNextPosition(from: from, to: to){
                  return true
              }
            }else{
               print("Cannot access this position!")            
            }
        } else{  //can fly so it does not have to be next position, only to be free
            if self.board.elemOnIndex(col: String(from.first!), row: Int(String(from.last!))! - 1) == player &&
               self.board.elemOnIndex(col: String(to.first!), row: Int(String(to.last!))! - 1) == "free" {
                  return true              
            }else{
               print("Cannot access this position!")            
            }
        }         
        return false
    }    
    func isGameOver()-> Bool{
        let player1_alive = 9 - self.player1.getDeathPiecesCount()
        let player2_alive = 9 - self.player2.getDeathPiecesCount()
        if player1_alive > 2 && player2_alive > 2{
            return false
        }        
        return true
    }
    func killOponentPiece(row: Int, col: String, oponent: Player) -> Bool{      
         if row >= 0 && row < 7 && col >= "A" && col <= "G"{
             if self.board.elemOnIndex(col: col, row: row) == oponent.getSymbolString(){
                 if isPossibleKill(row: row, col: col, player: oponent.getSymbolString()) {
                    _ = self.board.setPosition(col: col, row: row, player: "free")               
                    oponent.decrementPiecesOnBoardCount() 
                    oponent.deathPiece()
                    return true
                 }else{
                     print("This piece is in an opponent's mill and there are other available pieces!")
                 }                          
             }
         }
         print("Invalid Position!")         
         return false
    }
    //A piece in an opponent's mill can only be removed if no other pieces are available
    func isPossibleKill(row: Int, col: String, player: String) -> Bool{
         let colId : Int = Int((col.unicodeScalars.first)!.value - ("A".unicodeScalars.first)!.value)  
         //if the piece is in mill                 
         if isMill(row: row, col: colId, player: player){
            //if has another available piece that is not in mill
            if hasAvailablePiece(player: player){
                return false
            }
         }
        return true
    }
    //check wheather the given player has a piece that is not in a mill
    func hasAvailablePiece(player: String) -> Bool{
        let startColCode: Int = Int(("A".unicodeScalars.first)!.value)  //65
        let endColCode: Int = startColCode + 6
        for i in 0...6{
            for j in startColCode...endColCode{               
                let col: String = String(UnicodeScalar(j)!)   //A...G
                if self.board.elemOnIndex(col: col, row: i) == player && 
                   !(isMill(row: i, col: j - startColCode, player: player)){
                       return true
                   }
            }
        }
        return false
    } 
}
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
class Player{
    var Name: String
    var PiecesOnBoardCount: Int
    var DeathPiecesCount: Int
    var PieceSymbol: Character
    init(name: String, symbol: Character){
        self.Name = name
        self.PieceSymbol = symbol
        self.PiecesOnBoardCount = 0
        self.DeathPiecesCount = 0
    }
    func getSymbolString() -> String{
        return String(self.PieceSymbol)
    }
    func getPiecesOnBoardCount() -> Int{
        return self.PiecesOnBoardCount
    }
    func getDeathPiecesCount() -> Int{
        return self.DeathPiecesCount
    }
    func incrementPiecesOnBoardCount(){
        if self.PiecesOnBoardCount < 10{
           self.PiecesOnBoardCount += 1
        }        
    }
    func decrementPiecesOnBoardCount(){
        if self.PiecesOnBoardCount > 2{
            self.PiecesOnBoardCount -= 1
        }
    }
    func deathPiece(){
       self.DeathPiecesCount += 1
    }
}

let n = NineMensMorris()
n.Run()




