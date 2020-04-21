void setLinks() {
  final float A = 1 - 0.28 - 2 * 0.01 - 3 * 0.005;
  
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
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(matrix[i][j] + " ");
      if (matrix[i][j] == 1) vertexes.get(i).addLinks(vertexes.get(j));
    }
  }
  
  //---------- Other matrices ------------------
  
  for (Vertex v: vertexes)
  {
    v.findPathsWithLength(v.paths2, new ArrayList<Integer>(), 2, v);
    v.findPathsWithLength(v.paths3, new ArrayList<Integer>(), 3, v);
  }
  matrixLen2 = mult(matrix, matrix);
  matrixLen3 = mult(matrixLen2, matrix);
  println("\nШляхи довжиною 2:");
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(matrixLen2[i][j] + " ");
    }
  }
  println("\nШляхи довжиною 3:");
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(matrixLen3[i][j] + " ");
    }
  }
  int[][] accessMatrix 
      = add(add(matrix, matrixLen2), matrixLen3);
  for(int i = 0; i < GRAPH_COUNT; i++) {
    accessMatrix[i][i]++;
  }
  for (int i = 0; i < 8; i++)
  {
    matrixLen3 = mult(matrixLen3, matrix);
    accessMatrix = add(accessMatrix, matrixLen3);
  }
  println("\nМатриця досяжності:");
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      print(accessMatrix[i][j] + " ");
    }
  }
  int[][] transponedAcMatrix = new int[GRAPH_COUNT][GRAPH_COUNT];
  for (int i = 0; i < GRAPH_COUNT; i++) {
    for (int j = 0; j < GRAPH_COUNT; j++) {
      transponedAcMatrix[i][j] = accessMatrix[j][i];
    }
  }
  println("\nМатриця зв'язності:");
  for (int i = 0; i < GRAPH_COUNT; i++) {
    println();
    for (int j = 0; j < GRAPH_COUNT; j++) {
      transponedAcMatrix[i][j] *= accessMatrix[i][j];
      print(transponedAcMatrix[i][j] + " ");
    }
  }
  
  ArrayList<int[]> connectedComponents = new ArrayList<int[]>();
  for (int i = 0; i < GRAPH_COUNT; i++) {
    boolean newL = true;
    for (int[] line: connectedComponents) {
      if (equals(transponedAcMatrix[i], line)) {
        newL = false;
        break;
      }
    }
    if (newL) connectedComponents.add(transponedAcMatrix[i]);
  }
  
  for (int i = 0; i < connectedComponents.size(); i++) {
    condensVert.add(new Vertex(i + 1, width - 150, height / 2 + 370 + 150 * i));
  }
  for (int i = 0; i < connectedComponents.size(); i++) {
    for (int j = i + 1; j < connectedComponents.size(); j++) {
      int a = -1, b = -1;
      for (int k = 0; k < GRAPH_COUNT; k++) {
        if (a == -1 && connectedComponents.get(i)[k] == 1)
          a = k;
        if (b == -1 && connectedComponents.get(j)[k] == 1)
          b = k;
      }
      if (accessMatrix[a][b] == 1)
        condensVert.get(i).addLinks(condensVert.get(j));
      else if (accessMatrix[b][a] == 1)
        condensVert.get(j).addLinks(condensVert.get(i));
    }
  }
}

boolean equals(int[] a, int[] b) {
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}