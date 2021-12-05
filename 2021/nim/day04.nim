import strutils, sequtils

const board_size = 5

type
    Cell = tuple[num: int, marked: bool]
    Bingo = array[board_size, array[board_size, Cell]]

proc markBoard(board: var Bingo, num: int) =
    for row in 0..board.high:
        for col in 0..board[row].high:
            if board[row][col].num == num:
                board[row][col].marked = true
                return

proc winningBoard(board: Bingo): bool =
    var cols: seq[seq[Cell]]
    cols.newSeq(board.len)

    for row in 0..board.high:
        if board[row].allIt(it.marked):
            return true

        for col in 0..board[row].high:
            if cols[col].len == 0:
                cols[col].newSeq(board.len)

            cols[col][row] = board[row][col]

    if cols.anyIt(it.allIt(it.marked)):
        return true

proc sumUnmarked(board: Bingo): int =
    for row in board:
        for cell in row:
            if not cell.marked:
                result += cell.num

proc readBoardsInMem(): tuple[nums: seq[int], boards: seq[Bingo]] =
    let bingoLines = "../input/day4.txt".readFile.splitLines
    result.nums = bingoLines[0].split(',').map(parseInt)

    for boardIdx in countup(2, bingoLines.len - board_size, board_size + 1):
        var board: Bingo

        for row in 0 ..< board_size:
            let rowData = bingoLines[boardIdx + row].splitWhitespace.map(parseInt)
            for col in 0 ..< board_size:
                board[row][col] = (rowData[col], false)

        result.boards.add(board)

proc readBoardsIter(): tuple[nums: seq[int], boards: seq[Bingo]] =
    var atBoards: bool
    var currentBoard: Bingo
    var currentBoardRow: int

    for line in "../input/day4.txt".lines:
        if ',' in line:
            result.nums = line.split(',').map(parseInt)
            continue

        # skip empty line before first board
        if not atBoards:
            atBoards = true
            continue

        if line.isEmptyOrWhitespace:
            result.boards.add(currentBoard)
            # reset board somehow?
            currentBoardRow = 0
            continue

        let boardRow = line.splitWhitespace.map(parseInt)
        for col in 0..boardRow.high:
            currentBoard[currentBoardRow][col] = (boardRow[col], false)

        inc currentBoardRow

    result.boards.add(currentBoard)

var (nums, boards) = readBoardsInMem()
# var (nums, boards) = readBoardsIter()

var wonIdx: seq[int]

block game:
    for num in nums:
        for bIdx in 0..boards.high:
            if bIdx in wonIdx:
                continue

            boards[bIdx].markBoard(num)
            if boards[bIdx].winningBoard:
                wonIdx.add(bIdx)

                if wonIdx.len == 1:
                    echo boards[bIdx].sumUnmarked * num

                if wonIdx.len == boards.len:
                    echo boards[bIdx].sumUnmarked * num
                    break game