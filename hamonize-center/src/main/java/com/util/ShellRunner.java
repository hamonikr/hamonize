package com.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;


public class ShellRunner {

  public Map execCommand(String... str) {
    Map<Integer, String> map = new HashMap<>();
    ProcessBuilder pb = new ProcessBuilder(str);
    pb.redirectErrorStream(true);
    Process process = null;
    try {
        process = pb.start();
    } catch (IOException e) {
        e.printStackTrace();
    }

    BufferedReader reader = null;
    if (process != null) {
        reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
    }

    String line;
    StringBuilder stringBuilder = new StringBuilder();
    try {
        if (reader != null) {
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line).append("\n");
            }
        }
    } catch (IOException e) {
        e.printStackTrace();
    }

    try {
        if (process != null) {
            process.waitFor();
        }
    } catch (InterruptedException e) {
        e.printStackTrace();
    }

    if (process != null) {
        map.put(0, String.valueOf(process.exitValue()));
    }

    try {
        map.put(1, stringBuilder.toString());
    } catch (StringIndexOutOfBoundsException e) {
        if (stringBuilder.toString().length() == 0) {
            return map;
        }
    }
    return map;
  }
  public static void main(String args[]){
    String home = System.getProperty("user.home");
    String cmd = "dpkg --info "+home+"/uploads/1e7642da-ec75-4d71-9124-9ba4b195f8d7.deb | grep Package: \n"
    +"dpkg --info "+home+"/uploads/1e7642da-ec75-4d71-9124-9ba4b195f8d7.deb | grep Version:";
    String[] callCmd = {"/bin/bash", "-c", cmd};
    ShellRunner sr = new ShellRunner();
    Map map = sr.execCommand(callCmd);

    System.out.println(map);
    // String home = System.getProperty("user.home");
    // Process process;
    // process = Runtime.getRuntime().exec("");

  }
}
