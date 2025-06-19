import 'package:flutter/material.dart';
import 'dart:math';

class MazeRunnerViewModel extends ChangeNotifier {
  bool isPlaying = false;
  bool isGameOver = false;
  bool isWin = false;
  int score = 0;
  int level = 1;
  int collectedItems = 0;
  int totalItems = 0;

  // Configurações do labirinto
  int mazeWidth = 15;
  int mazeHeight = 15;
  List<List<MazeCell>> maze = [];

  // Posição do jogador
  int playerX = 1;
  int playerY = 1;

  // Posição da saída
  int exitX = 13;
  int exitY = 13;

  // Lista de itens coletáveis
  List<MazeItem> items = [];

  final Random random = Random();

  void startGame() {
    isPlaying = true;
    isGameOver = false;
    isWin = false;
    score = 0;
    collectedItems = 0;
    playerX = 1;
    playerY = 1;

    generateMaze();
    placeItems();

    notifyListeners();
  }

  void generateMaze() {
    // Inicializar labirinto com paredes
    maze = List.generate(mazeHeight, (y) {
      return List.generate(mazeWidth, (x) {
        return MazeCell(x: x, y: y, isWall: true, isVisited: false);
      });
    });

    // Gerar caminhos usando algoritmo de backtracking
    _generatePaths(1, 1);

    // Garantir que a entrada e saída estão abertas
    maze[1][1].isWall = false;
    maze[exitY][exitX].isWall = false;

    // Limpar células isoladas
    _cleanIsolatedCells();
  }

  void _generatePaths(int x, int y) {
    if (x < 0 || x >= mazeWidth || y < 0 || y >= mazeHeight) return;
    if (maze[y][x].isVisited) return;

    maze[y][x].isVisited = true;
    maze[y][x].isWall = false;

    // Direções: cima, direita, baixo, esquerda
    List<Point<int>> directions = [
      Point(0, -2), // cima
      Point(2, 0), // direita
      Point(0, 2), // baixo
      Point(-2, 0), // esquerda
    ];

    // Embaralhar direções
    directions.shuffle(random);

    for (Point<int> dir in directions) {
      int newX = x + dir.x;
      int newY = y + dir.y;

      if (newX > 0 &&
          newX < mazeWidth - 1 &&
          newY > 0 &&
          newY < mazeHeight - 1) {
        if (!maze[newY][newX].isVisited) {
          // Abrir caminho entre as células
          maze[y + dir.y ~/ 2][x + dir.x ~/ 2].isWall = false;
          _generatePaths(newX, newY);
        }
      }
    }
  }

  void _cleanIsolatedCells() {
    for (int y = 1; y < mazeHeight - 1; y++) {
      for (int x = 1; x < mazeWidth - 1; x++) {
        if (maze[y][x].isWall) {
          int wallCount = 0;
          if (maze[y - 1][x].isWall) wallCount++;
          if (maze[y + 1][x].isWall) wallCount++;
          if (maze[y][x - 1].isWall) wallCount++;
          if (maze[y][x + 1].isWall) wallCount++;

          // Se a célula está completamente isolada, abrir um caminho
          if (wallCount >= 3) {
            maze[y][x].isWall = false;
          }
        }
      }
    }
  }

  void placeItems() {
    items.clear();
    totalItems = level + 2; // Mais itens conforme o nível aumenta

    for (int i = 0; i < totalItems; i++) {
      int attempts = 0;
      while (attempts < 50) {
        int x = random.nextInt(mazeWidth - 2) + 1;
        int y = random.nextInt(mazeHeight - 2) + 1;

        // Verificar se a posição está livre
        if (!maze[y][x].isWall &&
            (x != playerX || y != playerY) &&
            (x != exitX || y != exitY) &&
            !items.any((item) => item.x == x && item.y == y)) {
          items.add(
            MazeItem(
              id: i,
              x: x,
              y: y,
              type: random.nextBool() ? ItemType.gem : ItemType.coin,
            ),
          );
          break;
        }
        attempts++;
      }
    }
  }

  void movePlayer(MazeDirection direction) {
    if (!isPlaying || isGameOver || isWin) return;

    int newX = playerX;
    int newY = playerY;

    switch (direction) {
      case MazeDirection.up:
        newY--;
        break;
      case MazeDirection.right:
        newX++;
        break;
      case MazeDirection.down:
        newY++;
        break;
      case MazeDirection.left:
        newX--;
        break;
    }

    // Verificar se a nova posição é válida
    if (newX >= 0 && newX < mazeWidth && newY >= 0 && newY < mazeHeight) {
      if (!maze[newY][newX].isWall) {
        playerX = newX;
        playerY = newY;

        // Verificar se coletou algum item
        checkItemCollection();

        // Verificar se chegou na saída
        checkWinCondition();

        // Adicionar pontos por movimento
        score += 1;

        notifyListeners();
      } else {
        // Game Over se tocar na parede
        endGame();
      }
    } else {
      // Game Over se sair dos limites
      endGame();
    }
  }

  void checkItemCollection() {
    items.removeWhere((item) {
      if (item.x == playerX && item.y == playerY) {
        collectedItems++;
        score += item.type == ItemType.gem ? 50 : 25;
        return true;
      }
      return false;
    });
  }

  void checkWinCondition() {
    if (playerX == exitX && playerY == exitY) {
      isWin = true;
      isPlaying = false;

      // Bônus por completar o nível
      score += 100;

      // Bônus por coletar todos os itens
      if (collectedItems == totalItems) {
        score += 200;
      }

      notifyListeners();
    }
  }

  void nextLevel() {
    level++;
    startGame();
  }

  void restartGame() {
    level = 1;
    startGame();
  }

  void endGame() {
    isPlaying = false;
    isGameOver = true;
    notifyListeners();
  }
}

class MazeCell {
  final int x;
  final int y;
  bool isWall;
  bool isVisited;

  MazeCell({
    required this.x,
    required this.y,
    required this.isWall,
    required this.isVisited,
  });
}

class MazeItem {
  final int id;
  final int x;
  final int y;
  final ItemType type;

  MazeItem({
    required this.id,
    required this.x,
    required this.y,
    required this.type,
  });
}

enum ItemType { coin, gem }

enum MazeDirection { up, right, down, left }
