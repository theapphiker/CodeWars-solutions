# Given an 8x8 chess board, this Python program finds the least number of moves for a knight to move from one point to another point.
# Link to challenge: https://www.codewars.com/kata/549ee8b47111a81214000941


def shortest_path(start, goal, d):
    f = goal
    c = 0
    for k in list(d.keys())[::-1]:
        for e in d[k]:
            if e == f:
                c += 1
                f = k
        if f == start:
            return c


def board_points(p1, p2):
    board = [
        ["a8", "b8", "c8", "d8", "e8", "f8", "g8", "h8"],
        ["a7", "b7", "c7", "d7", "e7", "f7", "g7", "h7"],
        ["a6", "b6", "c6", "d6", "e6", "f6", "g6", "h6"],
        ["a5", "b5", "c5", "d5", "e5", "f5", "g5", "h5"],
        ["a4", "b4", "c4", "d4", "e4", "f4", "g4", "h4"],
        ["a3", "b3", "c3", "d3", "e3", "f3", "g3", "h3"],
        ["a2", "b2", "c2", "d2", "e2", "f2", "g2", "h2"],
        ["a1", "b1", "c1", "d1", "e1", "f1", "g1", "h1"],
    ]
    for r in range(len(board)):
        for c in range(len(board[0])):
            if board[r][c] == p1:
                start = (r, c)
            elif board[r][c] == p2:
                goal = (r, c)
    return start, goal, board


def knight(p1, p2):
    start, goal, board = board_points(p1, p2)
    parent_nodes = {}
    frontier = [start]
    explored = []
    while len(frontier) > 0:
        curr_node = frontier.pop(0)
        if curr_node == goal:
            return shortest_path(start, goal, parent_nodes)
        locations = []
        if curr_node[0] - 2 >= 0 and curr_node[1] - 1 >= 0:
            locations.append((curr_node[0] - 2, curr_node[1] - 1))
        if curr_node[0] - 2 >= 0 and curr_node[1] + 1 <= len(board[0]) - 1:
            locations.append((curr_node[0] - 2, curr_node[1] + 1))
        if curr_node[0] - 1 >= 0 and curr_node[1] - 2 >= 0:
            locations.append((curr_node[0] - 1, curr_node[1] - 2))
        if curr_node[0] - 1 >= 0 and curr_node[1] + 2 <= len(board[0]) - 1:
            locations.append((curr_node[0] - 1, curr_node[1] + 2))
        if curr_node[0] + 2 <= len(board) - 1 and curr_node[1] - 1 >= 0:
            locations.append((curr_node[0] + 2, curr_node[1] - 1))
        if curr_node[0] + 2 <= len(board) - 1 and curr_node[1] + 1 <= len(board[0]) - 1:
            locations.append((curr_node[0] + 2, curr_node[1] + 1))
        if curr_node[0] + 1 <= len(board) - 1 and curr_node[1] - 2 >= 0:
            locations.append((curr_node[0] + 1, curr_node[1] - 2))
        if curr_node[0] + 1 <= len(board) - 1 and curr_node[1] + 2 <= len(board[0]) - 1:
            locations.append((curr_node[0] + 1, curr_node[1] + 2))
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
