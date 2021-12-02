import algorithm, deques, tables, sequtils, strscans

type
    Route = tuple[destination: string, distance: int]
    FullRoute = tuple[start: string, dest: string, distance: int]

type
    City = ref object
        name: string
        routes: seq[Route]
        visited: bool

proc `$`(c: City): string = 
    return c.name

proc parseRoute(input: string): FullRoute = 
    let (success, start, dest, distance) = scanTuple(input, "$w to $w = $i")
    if not success:
        raise newException(Exception, "parsing error")
    
    return (start, dest, distance)

var cities: Table[string, City]

proc addRoute(startCity: string, endCity: string, distance: int) = 
    if not cities.contains(startCity):
        cities[startCity] = City(name: startCity)

    if not cities.contains(endCity):
        cities[endCity] = City(name: endCity)

    cities[startCity].routes.add((endCity, distance))
    cities[endCity].routes.add((startCity, distance))

proc getDistance(cityList: var seq[string], cities: Table[string, City]): int =
    for i in 0 ..< cityList.high:
        let fromCity = cityList[i]
        let toCity = cityList[i + 1]

        result += cities[fromCity].routes.filterIt(it.destination == toCity)[0].distance    

# TODO: Floyd-Warshall, travelling salesman
proc visitCities(cities: Table[string, City]) =
    for (city, info) in cities.pairs:
        var travel: Deque[City]

        info.visited = true
        travel.addFirst(info)

        echo "start ", travel

        while travel.len > 0:
            let current = travel.popFirst()
            
            for (dest, dist) in current.routes:
                let destInfo = cities[dest]

                if not destInfo.visited:
                    travel.addFirst(destInfo)
                    destInfo.visited = true

                echo travel

for line in "../input/day9.txt".lines:
    let route = parseRoute(line)
    addRoute(route.start, route.dest, route.distance)

var cityList = cities.keys.toSeq

cityList.sort()

var shortestDist, longestDist = getDistance(cityList, cities)
while cityList.nextPermutation:
    let distance = getDistance(cityList, cities)
    shortestDist = min(shortestDist, distance)
    longestDist = max(longestDist, distance)

echo shortestDist
echo longestDist