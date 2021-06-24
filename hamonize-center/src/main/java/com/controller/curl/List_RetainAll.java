package com.controller.curl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class List_RetainAll {

	public static void main(String[] args) {

		List<String> list = new ArrayList<>();
		list.add("3");
		list.add("4");
		list.add("5");
		list.add("6");
		list.add("3");
		list.add("4");
		list.add("5");
		list.add("1");
		list.add("2");

		Map<String, Integer> map = new HashMap<>();
		for (String temp : list) {
			Integer count = map.get(temp);
			map.put(temp, (count == null) ? 1 : count + 1);
		}
		printMap(map);
		
		System.out.println("=============");
		test1();

	}

	private static void printMap(Map<String, Integer> map) {
		List<List<String>> secondStrings = new ArrayList<>();

		for (Map.Entry<String, Integer> entry : map.entrySet()) {
			System.out.println("Element : " + entry.getKey() + " Count : " + entry.getValue());
			
			if( entry.getValue() == 1 ) {
				secondStrings.add(makeArray(entry.getKey(), entry.getValue()));	
			}
		
			
		}
		System.out.println(secondStrings.toString());

	}

	private static List<String> makeArray(String key, Integer value) {
		List<String> firstStrings = new ArrayList<>();
		for (int i = 0; i < value; i++) {
			firstStrings.add(key);
		}
		return firstStrings;
	}

	
	
	public static void test1() {
		final List<String> ori = new ArrayList<String>();
		ori.add("1");
		ori.add("2");
		ori.add("3");

		List<String> oriCOPY = new ArrayList<String>();
		oriCOPY.addAll(ori);

		List<String> target1 = new ArrayList<String>();
		target1.add("2");
		target1.add("6");

		target1.retainAll(oriCOPY);

		for (String set : target1) {
			System.out.println("set====" + set);
		}

		System.out.println("===============");
	}

}
