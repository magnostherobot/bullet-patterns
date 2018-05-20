int HEIGHT = 700;
int WIDTH  = 700;

static BulletTemplate bt;
static FireTemplate ft;
static HashMap<Integer, FireTemplate> hm;

static CirclePattern cp;
static CirclePattern cp2;
static PatternPattern pp;

void setup() {
  size(700, 700);
  
  bt = new BulletTemplate(1);
  ft = new FireTemplate(4, bt);
  hm = new HashMap<Integer, FireTemplate>();
  hm.put(0, ft);
  cp = new CirclePattern(hm, 5, 0.03);
  cp2 = new CirclePattern(hm, 5, -0.03);
  ArrayList<Fireable> al = new ArrayList<Fireable>();
  al.add(cp);
  al.add(cp2);
  pp = new PatternPattern(al, 0.01);
}

void draw() {
  background(0);
  stroke(255);
  point(20, 20);
  pp.fire();
  pp.move();
  pp.draw();
}

abstract class Fireable {
  public void fire() {
    fire(0);
  }
  public abstract void fire(float offset);
  public abstract void move();
  public abstract void draw();
}

class PatternPattern extends Fireable {
  int life = 0;
  Iterable<Fireable> patterns;
  float rate;

  public PatternPattern(Iterable<Fireable> patterns, float rate) {
    this.patterns = patterns;
    this.rate = rate;
  }

  public void fire(float offset) {
    life++;
    for (Fireable p : patterns) {
      p.fire(rate * life + offset);
    }
  }

  public void move() {
    for (Fireable p : patterns) {
      p.move();
    }
  }

  public void draw() {
    for (Fireable p : patterns) {
      p.draw();
    }
  }
}

class CirclePattern extends Fireable {
  int life = 0;
  int cycle;
  public BulletGroup bulletGroup = new BulletGroup();
  HashMap<Integer, FireTemplate> events;
  float rate;

  public CirclePattern(HashMap<Integer, FireTemplate> events, int cycle, float rate) {
    this.events = events;
    this.cycle = cycle;
    this.rate = rate;
  }

  public void fire(float offset) {
    life++;
    FireTemplate ft = events.get(life % cycle);
    if (ft != null) {
      ft.fire(bulletGroup, life * rate + offset);
    }
  }

  public void move() {
    bulletGroup.move();
  }

  public void draw() {
    bulletGroup.draw();
  }
}

class FireTemplate {
  public int number;
  public BulletTemplate bulletTemplate;

  public FireTemplate(int number, BulletTemplate bulletTemplate) {
    this.number = number;
    this.bulletTemplate = bulletTemplate;
  }

  public void fire(BulletGroup bg, float offset) {
    for (int i = 0; i < number; ++i) {
      Bullet b = new Bullet(bulletTemplate, HEIGHT / 2, WIDTH / 2, 2 * PI / number * i + offset);
      bg.add(b);
    }
  }
}

class BulletTemplate {
  public float vel;

  public BulletTemplate(float vel) {
    this.vel = vel;
  }
}

class Bullet {
  public BulletTemplate bulletTemplate;
  public float theta;
  public float pos_x;
  public float pos_y;

  public Bullet(BulletTemplate bulletTemplate, float pos_x, float pos_y, float theta) {
    this.bulletTemplate = bulletTemplate;
    this.pos_x = pos_x;
    this.pos_y = pos_y;
    this.theta = theta;
  }

  public void move() {
    this.pos_x += bulletTemplate.vel * cos(theta);
    this.pos_y += bulletTemplate.vel * sin(theta);
  }

  public void draw() {
    point(pos_x, pos_y);
  }
}

class BulletGroup {
  ArrayList<Bullet> bullets = new ArrayList<Bullet>();

  public void add(Bullet b) {
    bullets.add(b);
  }

  public void move() {
    for (Bullet b : bullets) {
      b.move();
    }
  }

  public void draw() {
    for (Bullet b : bullets) {
      b.draw();
    }
  }
}
