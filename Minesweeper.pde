import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 21;
public final static int NUM_COLS = 21;
private int maxMines = 100;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i++)
        for (int j = 0; j < NUM_COLS; j++)
            buttons[i][j] = new MSButton (i,j);

    
    
    setMines();
}
public void setMines()
{
    
    for (int i = 0; i < maxMines; i++){
        int rr = (int)(NUM_ROWS * Math.random());
        int cc = (int)(NUM_COLS * Math.random());
        if(!mines.contains(buttons[rr][cc])){
            mines.add(buttons[rr][cc]);
        } else {
            rr = (int)(NUM_ROWS * Math.random());
            cc = (int)(NUM_COLS * Math.random());
        }
    }
    

}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int xMine = 0;
    for(int r=0; r<NUM_ROWS; r++)
    {
        for(int c=0; c<NUM_COLS; c++)
        {
            if(!mines.contains(buttons[r][c]) && buttons[r][c].isClicked())
                xMine++;
        }
    }
    if(xMine==(NUM_COLS*NUM_ROWS)-maxMines)
        return true;
    
    return false;
}
public void displayLosingMessage()
{
    //your code here
    redraw();
    String losing = "DROP IT LIKE A BOMB";
    for(int l = 6; l < NUM_ROWS-6; l++)
        for (int lo = 1; lo < losing.length()+1; lo++)
            buttons[l][lo].setLabel(losing.substring(lo-1,lo));

    for (MSButton mine : mines)
        mine.donedone(true);




}
public void displayWinningMessage()
{
    //your code here
    String losing = "YAY WE GOT A WINNER!!";
    for(int l = 1; l < 3; l++)
        for (int lo = 0; lo < losing.length(); lo++)
            buttons[l][lo].setLabel(losing.substring(lo,lo+1));

    for(int l = 18; l < 20; l++)
        for (int lo = 0; lo < losing.length(); lo++)
            buttons[l][lo].setLabel(losing.substring(lo,lo+1));
}
public boolean isValid(int r, int c)
{
    //your code here
    if (r>=0 && c>=0)
        if (r<=NUM_ROWS && c<=NUM_COLS)
            return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
    for (int i = row-1; i <= row+1; i++)
        for (int j = col-1; j <= col+1; j++)
            if(isValid(i,j)&&mines.contains(buttons[i][j]))
                numMines++;
    return numMines;
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = row;
        c = col; 
        x = c*width;
        y = r*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        //clicked = true;
        //your code here
        if(mouseButton==LEFT && !flagged)
            clicked = true;
        if(mouseButton==RIGHT && !clicked)
            flagged = !flagged;
        else if (mines.contains(this) && !flagged)
            displayLosingMessage();
        else if (countMines(r,c)>0){
            myLabel = ""+countMines(r,c);
            if (mines.contains(buttons[r][c])) 
                myLabel = "";
        }
        // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ H
        else{
            for (int i = r-1; i <= r+1; i++)
                for (int j = c-1; j <= c+1; j++)
                    if (isValid(i,j) && !buttons[i][j].isClicked())
                        buttons[i][j].mousePressed();
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,90,90);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked(){
        return clicked;
    }
    public void donedone (boolean o){
        clicked = o;
    }
}
