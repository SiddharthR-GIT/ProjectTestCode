public class TitleValid {
    if( title.equals("driver".toUpperCase())    ||
        title.equals("passenger".toUpperCase()) ||
        title.equals("DRIVER".toLowerCase())    ||
        title.equals("PASSENGER".toLowerCase()) ||
        title.equals("Driver")                  ||
        title.equals("Passenger")){
            return true;
        }
        else{
            return false;
        }
    }
}
