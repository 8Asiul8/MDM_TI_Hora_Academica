Capture cap;
int dir; //0 -> nada || 1 -> direita || 2 -> esquerda

PImage silhueta; //Silhueta das pessoas que estão a passar
PImage stateOri; //Imagem que com a qual a imagem captada pela câmera vai ser comprada
PImage back;     //Soma de todas as silhuetas captadas sobrepostas

boolean aCaptar;
boolean aCaptarLastStat;
ArrayList <PImage> framesIns = new ArrayList<PImage>();
PImage silCol;
//ArrayList <PImage> allFrames = new ArrayList<PImage>();

float h; //Hue a variar de acordo com a hora 

Serial portaSerial;
String dadosRecebidos;
boolean ligado; //Se o programa está ativo ou não

//Programar Tresholds
float tresholdStateOriRep = 1. / 4.; //O numero de pixeis que são tolerados como modificados
float tresholdNoFrame = 1. / 2.; //Não salva a silhieta se o numero de pixeis for superior a este valor
boolean modoResStateOri = false; //modo em que o pgrama tenta corrigir a imagem original
int tempoFalhaDet = 0;  //Uma quantidade muito alta de pixels alterados está a ser detetada (indica um problema na imagem original)


int modoDoProg = 0;

//PASTA
String dateStr = new SimpleDateFormat("yyyy-MM-dd").format(new Date());
String folderPath = sketchPath(dateStr);
File folder = new File(folderPath);

File[] files;
ArrayList <PImage> passagens = new ArrayList<PImage>();
int[] timePass;

dados[] blocosTempo = new dados[96];
float espacamento;
int selec = -1;  //Na Visualização, esta indica o intervalo de tempo a ser visualizado
