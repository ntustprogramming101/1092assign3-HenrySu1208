final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;
int lifeNum = 2;
final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg, soil0, soil1, soil2, soil3, soil4, soil5, stone1, stone2, life;
PImage groundhog, groundhogDown, groundhogLeft, groundhogRight;

float cameraMoveY = 0;
float block = 80;
float blockAccount = 8;
float wholeSeg = 24;
float groundhogX = block*4;
float groundhogY = block;

//Moves Setting reference
float groundhogSpeed = 4;
float groundhogWidth = 80;
float groundhogHeight = 80;
int down = 0;
int right = 0;
int left = 0;
float step = 80.0;
int frames = 15;

boolean upPressed = false;
boolean downPressed = false;
boolean rightPressed = false;
boolean leftPressed = false;



// For debug function; DO NOT edit or remove this!
int playerHealth = 0;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("bg.jpg");
  title = loadImage("title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  life = loadImage("img/life.png");
  soil0 = loadImage("img/soil0.png");
  soil1 = loadImage("img/soil1.png");
  soil2 = loadImage("img/soil2.png");
  soil3 = loadImage("img/soil3.png");
  soil4 = loadImage("img/soil4.png");
  soil5 = loadImage("img/soil5.png");
  stone1 = loadImage("img/stone1.png");
  stone2 = loadImage("img/stone2.png");
  groundhog = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
}

void draw() {
  /* ------ Debug Function ------ 
   
   Please DO NOT edit the code here.
   It's for reviewing other requirements when you fail to complete the camera moving requirement.
   
   */
  if (debugMode) {
    pushMatrix();
    translate(0, cameraOffsetY);
  }
  /* ------ End of Debug Function ------ */

  switch (gameState) {

  case GAME_START: // Start Screen
    image(title, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
      }
    } else {

      image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;

  case GAME_RUN: // In-Game
    // Background
    image(bg, 0, 0);

    // Sun
    stroke(255, 255, 0);
    strokeWeight(5);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120);
    pushMatrix();
    translate(0, cameraMoveY);

    // Grass
    fill(124, 204, 25);
    noStroke();
    rect(0, 160 - GRASS_HEIGHT, width, GRASS_HEIGHT);

    // Soil
    for (int i = 0; i<blockAccount; i++) {
      for (int j = 0; j<blockAccount/2; j++) {
        float x = i*block;
        float y0 = block*2 + j*block;
        float y1 = block*6 + j*block;
        float y2 = block*10 + j*block;
        float y3= block*14 + j*block;
        float y4= block*18 + j*block;
        float y5= block*22 + j*block;

        image(soil0, x, y0);
        image(soil1, x, y1);
        image(soil2, x, y2);
        image(soil3, x, y3);
        image(soil4, x, y4);
        image(soil5, x, y5);
      }
    }

    //Stone1-8
    for (int i = 0; i<blockAccount; i++) {
      float x = block*i;
      float y = block*2 + block*i;
      image(stone1, x, y);
    }
    //stone9-16
    for (int k = 0; k < 8; k+=4 ) {
      for (int j = 0; j<width; j+=4) {
        for (int i = 0; i<blockAccount/2; i++) {
          float a = -block*2 +block*i;
          float b = block*10 + block*i;
          float c = block*1 + block*-i;
          float d = block*10 + block*i;
          image(stone1, a+block*j, b+block*k);
          image(stone1, c+block*j, d+block*k);
        }
      }
    }
    //stone17-24
    for (int k = 0; k<2; k+=1) {
      for (int j = 0; j<width; j+=3) {
        for (int i =0; i<blockAccount; i++) {
          float a = -block*2 + block*-i;
          float b = block*18 + block*i;
          float c = block*2 + block*-i;
          float d = block*18 + block*i;
          image(stone1, a + block*j + block*k, b);
          image(stone2, c + block*j, d);
        }
      }
    }

    // Player
    if (down > 0) {
      if (down == 1) {
        groundhogY = round(groundhogY + step/frames);
        image(groundhog, groundhogX, groundhogY);
      } else {
        groundhogY = groundhogY + step/frames;
        image(groundhogDown, groundhogX, groundhogY);
      }
      down -=1;
    }

    //left
    if (left > 0) {
      if (left == 1) {
        groundhogX = round(groundhogX - step/frames);
        image(groundhog, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX - step/frames;
        image(groundhogLeft, groundhogX, groundhogY);
      }
      left -=1;
    }

    //right
    if (right > 0) {
      if (right == 1) {
        groundhogX = round(groundhogX + step/frames);
        image(groundhog, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX + step/frames;
        image(groundhogRight, groundhogX, groundhogY);
      }
      right -=1;
    }

    //no move
    if (down == 0 && left == 0 && right == 0 ) {
      image(groundhog, groundhogX, groundhogY);
    }
    //image(groundhog, groundhogX, groundhogY);
    popMatrix();
    // Health UI
    for (int x = 0; x < lifeNum; x++) {
      image(life, 10 + x*70, 10);
    }
    break;

  case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);

    if (START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if (mousePressed) {
        gameState = GAME_RUN;
        mousePressed = false;
        // Remember to initialize the game here!
      }
    } else {

      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }
  // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
  if (debugMode) {
    popMatrix();
  }
}

void keyPressed() {
  // Add your moving input code here
  if (down>0 || left>0 || right>0) {
    return;
  }
  if (key == CODED) {
    switch(keyCode) {
    case DOWN:
      if (groundhogY < block*25) {
        downPressed = true;
        if (groundhogY<21*block) {
          cameraMoveY -=80;
        }
        down = 15;
      }
      break;
    case LEFT:
      if (groundhogX > 0) {
        leftPressed = true;
        left = 15;
      }
      break;
    case RIGHT:
      if (groundhogX < 560) {
        rightPressed = true;
        right = 15;
      }
      break;
    }
  }


  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
  switch(key) {
  case 'w':
    debugMode = true;
    cameraOffsetY += 25;
    break;

  case 's':
    debugMode = true;
    cameraOffsetY -= 25;
    break;

  case 'a':
    if (playerHealth > 0) playerHealth --;
    break;

  case 'd':
    if (playerHealth < 5) playerHealth ++;
    break;
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}

