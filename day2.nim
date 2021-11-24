from std/strscans import scanf

proc getDimensions(dimensions: string): tuple[l: int, w: int, h: int] =
    var l, w, h: int
    if (scanf(dimensions, "$ix$ix$i", l, w, h)):
        return (l, w, h)

proc calculatePaperSize(dimensions: string): int =
    let (l, w, h) = getDimensions(dimensions)
    
    let lw = l * w
    let wh = w * h
    let hl = h * l

    let smallestArea = min([lw, wh, hl])
    
    return (2 * lw) + (2 * wh) + (2 * hl) + smallestArea

proc calculateRibbonSize(dimensions: string): int =
    let (l, w, h) = getDimensions(dimensions)

    let lw = 2 * l + 2 * w
    let wh = 2 * w + 2 * h
    let hl = 2 * h + 2 * l

    let smallestPerimeter = min([lw, wh, hl])
    
    return l * w * h + smallestPerimeter

var totalPaper, totalRibbon = 0
for giftSize in "input/day2.txt".lines:
    totalPaper += calculatePaperSize(giftSize)
    totalRibbon += calculateRibbonSize(giftSize)

echo totalPaper
echo totalRibbon