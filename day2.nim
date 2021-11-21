from strscans import scanf

proc getDimensions(dimensions: string): tuple[l: int, w: int, h: int] =
    var l, w, h: int
    if (scanf(dimensions, "$ix$ix$i", l, w, h)):
        return (l, w, h)

proc calculatePaperSize(dimensions: string): int =
    let dims = getDimensions(dimensions)
    
    let lw = dims.l * dims.w
    let wh = dims.w * dims.h
    let hl = dims.h * dims.l

    let smallestArea = min(@[lw, wh, hl])
    
    return (2 * lw) + (2 * wh) + (2 * hl) + smallestArea

proc calculateRibbonSize(dimensions: string): int =
    let dims = getDimensions(dimensions)

    let lw = 2 * dims.l + 2 * dims.w
    let wh = 2 * dims.w + 2 * dims.h
    let hl = 2 * dims.h + 2 * dims.l

    let smallestPerimeter = min(@[lw, wh, hl])
    
    return dims.l * dims.w * dims.h + smallestPerimeter

var totalPaper, totalRibbon = 0
for giftSize in "day2_input.txt".lines:
    totalPaper += calculatePaperSize(giftSize)
    totalRibbon += calculateRibbonSize(giftSize)

echo totalPaper
echo totalRibbon