import com.cpjd.main.*;
import com.cpjd.models.*;
import com.cpjd.models.other.*;
import com.cpjd.requests.*;
import com.cpjd.utils.*;

import org.json.simple.*;
import org.json.simple.parser.*;


TBA tba;
ArrayList<Team> teams;
com.cpjd.models.Event[] events;
PrintWriter log;
int week;

  int MICHIGAN = 1, MID_ATLANTIC = 2, NEW_ENGLAND = 3, PACIFIC_NORTHWEST = 4,
  INDIANA = 5, CHESAPEAKE = 6, NORTH_CAROLINA = 7, GEORGIA = 8, ONTARIO = 9,
  ISRAEL = 10;

  void setup() {
  size(300, 300, P2D);

  TBA.setID("cadandcookiesatgmail", "RCA Info App", "V0.1");
  Settings.GET_EVENT_AWARDS = true;
  tba = new TBA();
  println("Initialized TBA");
  log = createWriter("log.txt");
  println("Initialized writer");

  //test();

  println("Making TBA Request");
  events = tba.getEvents(2017);
  println("TBA Requests received");

  test();
}

void keyPressed() {

  switch (key) {
  case '1': 
    week = 1;
    printRegionalCAWinners(week);
    break;
  case '2': 
    week = 2;
    printRegionalCAWinners(week);
    break;
  case '3': 
    week = 3;
    printRegionalCAWinners(week);
    break;
  case '4': 
    week = 4;
    printRegionalCAWinners(week);
    break;
  case '5': 
    week = 5;
    printRegionalCAWinners(week);
    break;
  case '6': 
    week = 6;
    printRegionalCAWinners(week);
    break;
  case '7': 
    week = 7;
    printRegionalCAWinners(week);
    break;
  case '8': 
    week = 8;
    printRegionalCAWinners(week);
    break;
  case '9': 
    week = 9;
    printRegionalCAWinners(week);
    break;
  case 'e': 
    cleanup();
    exit();
  case 'E': 
    cleanup();
    exit();
  case 'p': 
    printEvents();
  case 'P': 
    printEvents();
  }
}

void test() {

  printWeekPrintout(5);
  printWeekPrintout(6);
  printWeekPrintout(7);

  cleanup();
  exit();
}

Team getTeam(int team) {
  log.println("Requesting Team Data for Team " + team);
  try {
    Team t = tba.getTeam(team);
    log.println("Successfully retrieved team data");
    return t;
  } 
  catch(Exception e) {
    log.println("EXCEPTION: FAILED TO RETRIEVE TEAM DATA");
  }

  return null;
}

Award[] getTeamAwardHistory(int team) {
  log.println("Requesting Team Awards History for Team " + team);
  try {
    Award[] a = tba.getTeamHistoryAwards(team);
    log.println("Successfully retrieved team awards history");
    return a;
  } 
  catch(Exception e) {
    log.println("EXCEPTION: FAILED TO RETRIEVE TEAM AWARD HISTORY");
  }

  return null;
}

String getTeamInfoString(Team team) {
  String s = new String();

  s += team.nickname;
  s += ",";
  s += team.team_number;
  s += ",";
  s += team.locality;
  s += ",";
  s += team.region;
  s +=","; 
  s += team.country_name;
  s += ",";
  s += team.rookie_year;
  return s;
}

void printTeamInfo(PrintWriter out, Team team) {
  out.println(getTeamInfoString(team));
}

String getAwardInfoString(Award award) {
  String s = new String();

  s += award.name;
  s += ",";
  s += award.year;
  s += ",";
  s += award.event_key;
  return s;
}

void printChairmansAwards(PrintWriter out, Award[] awards) {  
  for (Award award : awards) {
    if (award.award_type == 0) {
      out.println(getAwardInfoString(award));
    }
  }
}

void printEngineeringInspirationAwards(PrintWriter out, Award[] awards) {
  for (Award award : awards) {
    if (award.award_type == 9) {
      out.println(getAwardInfoString(award));
    }
  }
}

void printEventInfo(PrintWriter out, com.cpjd.models.Event event) {
  out.println(event.short_name + "," + event.year);
}

void printRegionalCAWinners(int week) {
  PrintWriter out = createWriter("week" + week + "RegionalWinners.txt");
  log.println("Printing Week " + week + " Regional Chairman's Award Winners");
  out.println("Week " + week + " Regional Chairman's Award Winners: ");

  int winner;
  Team team;
  Award[] awards;
  for (com.cpjd.models.Event event : events) {

    if (event.event_type == 0 && event.week == week - 1) {
      printEventInfo(out, event);
      for (Award a : event.awards) {
        if (a.award_type == 0) {
          winner = (int) a.recipient_list[0].team_number;

          team = getTeam(winner);
          printTeamInfo(out, team);

          awards = getTeamAwardHistory(winner);
          printChairmansAwards(out, awards);
          printEngineeringInspirationAwards(out, awards);
        }
      }
    }
  }

  out.flush();
  out.close();

  log.println("Finished printing Week " + week + " Regional Chairman's Award Winners");
}

void printWeekPrintout(int week){
  ArrayList<com.cpjd.models.Event> events = getRegionalEvents(week);
  for(com.cpjd.models.Event e : events){
    printEventCAInfo(e);
  }
  
}

ArrayList<com.cpjd.models.Event> getRegionalEvents(int week) {
  ArrayList<com.cpjd.models.Event> e = new ArrayList<com.cpjd.models.Event>();
  for (com.cpjd.models.Event event : events) {
    if (event.event_type == 0 && event.week == week - 1) {
      e.add(event);
    }
  }

  return e;
}

void printEventCAInfo(com.cpjd.models.Event event) {
  PrintWriter out = createWriter(event.key + "info.txt");

  for (Team team : event.teams) {
    printTeamInfo(out, team);
    Award[] awards = getTeamAwardHistory((int)team.team_number);
    printChairmansAwards(out, awards);
    printEngineeringInspirationAwards(out, awards);
  }

  out.flush();
  out.close();
}

void printEvents() {
  println("Printing Events");
  for (int i = 0; i < events.length; i++) {
    log.println(events[i].name);
  }
  println("Finished printing events");
}

void draw() {
  update();
  background(0);
}

void update() {
}

void cleanup() {
  log.flush();
  log.close();
}