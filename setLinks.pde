void setLinks() {
  final float A = 1 - 0.25 - 2 * 0.01 - 3 * 0.005;
  
  int[][] matrix = new int[GRAPH_COUNT][GRAPH_COUNT];
  int[][] matrixLen2 = new int[GRAPH_COUNT][GRAPH_COUNT];
  int[][] matrixLen3 = new int[GRAPH_COUNT][GRAPH_COUNT];
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      matrix[i][j] = floor((random(1) + random(1)) * A);
    }
  }
  
  if (!DIRECTED) {
  int[][] transponed = new int[GRAPH_COUNT][GRAPH_COUNT];
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      transponed[i][j] = matrix[i][j];
    }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = i + 1; j < GRAPH_COUNT; j++) {
      int temp = transponed[i][j];
      transponed[i][j] = transponed[j][i];
      transponed[j][i] = temp;
    }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      matrix[i][j] += transponed[i][j];
      if (matrix[i][j] == 2) matrix[i][j] = 1;
    }
  }
  }
  
  for (int i = 0; i < GRAPH_COUNT; i++) {
    matrix[i][i] = 0;
  }
  
  ///
  
  int[][] triangle = new int[GRAPH_COUNT][GRAPH_COUNT];
  int[][] Wt = new int[GRAPH_COUNT][GRAPH_COUNT];
  int[][] W = new int[GRAPH_COUNT][GRAPH_COUNT];
  boolean[][] B = new boolean[GRAPH_COUNT][GRAPH_COUNT];
  
  for (int j = 0; j < GRAPH_COUNT; j++) {
    for (int i = j - 1; i >= 0; i--) {
      triangle[i][j] = 1;
    }
  }

  for (int j = 0; j < GRAPH_COUNT; j++) {
    for (int i = 0; i < GRAPH_COUNT; i++) {
      Wt[i][j] = (int) random(100) * matrix[i][j];
    }
  }

  for (int j = 0; j < GRAPH_COUNT; j++) {
    for (int i = 0; i < GRAPH_COUNT; i++) {
      B[i][j] = bool(Wt[i][j]);
    }
  }

  for (int j = 0; j < GRAPH_COUNT; j++) {
    for (int i = 0; i < GRAPH_COUNT; i++) {
      Wt[i][j] = integ(B[i][j] && !B[j][i] || B[i][j] && B[j][i]) * triangle[i][j] * Wt[i][j];
    }
  }

  for (int j = 0; j < GRAPH_COUNT; j++) {
    println();
    for (int i = 0; i < GRAPH_COUNT; i++) {
      W[i][j] = Wt[i][j] + Wt[j][i];
      print(W[i][j] + " ");
    }
  }
  
  println();
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(matrix[i][j] + " ");
      if (matrix[i][j] == 1) vertexes.get(i).addLink(vertexes.get(j), W[i][j]);
    }
  }
}

boolean equals(int[] a, int[] b) {
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

boolean bool(int a) {
  return a != 0;
}
int integ(boolean a) {
  return a ? 1 : 0;
}