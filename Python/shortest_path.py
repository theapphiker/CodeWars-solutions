# This method returns the length of the shortest path in a maze. Link to challenge: https://www.codewars.com/kata/57658bfa28ed87ecfa00058a


def shortest_path(goal, d):
    start = (0, 0)
    f = goal
    c = 0
    for k in list(d.keys())[::-1]:
        for e in d[k]:
            if e == f:
                c += 1
                f = k
        if f == start:
            return c


def path_finder(maze):
    maze = maze.split("\n")
    start = (0, 0)
    goal = (len(maze) - 1, len(maze[0]) - 1)
    parent_nodes = {}
    frontier = [start]
    explored = []
    while len(frontier) > 0:
        curr_node = frontier.pop(0)
        if curr_node == goal:
            return shortest_path(goal, parent_nodes)
        locations = []
        if curr_node[0] - 1 >= 0 and maze[curr_node[0] - 1][curr_node[1]] != "W":
            locations.append((curr_node[0] - 1, curr_node[1]))
        if (
            curr_node[0] + 1 <= len(maze) - 1
            and maze[curr_node[0] + 1][curr_node[1]] != "W"
        ):
            locations.append((curr_node[0] + 1, curr_node[1]))
        if curr_node[1] - 1 >= 0 and maze[curr_node[0]][curr_node[1] - 1] != "W":
            locations.append((curr_node[0], curr_node[1] - 1))
        if (
            curr_node[1] + 1 <= len(maze[0]) - 1
            and maze[curr_node[0]][curr_node[1] + 1] != "W"
        ):
            locations.append((curr_node[0], curr_node[1] + 1))
        for child in locations:
            if child in explored:
                continue
            explored.append(child)
            frontier.append(child)
            if curr_node not in parent_nodes.keys():
                parent_nodes[curr_node] = [child]
            else:
                parent_nodes[curr_node].append(child)
    return False
