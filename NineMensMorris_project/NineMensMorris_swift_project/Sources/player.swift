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