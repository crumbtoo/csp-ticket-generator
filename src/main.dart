import "dart:html";
import 'dart:collection';
import 'dart:convert';
import 'dart:async';
import "dart:io";
import "package:http/http.dart" as http;

import "catppuccin.dart";

enum days
{
	sunday,
	monday,
	tuesday,
	wednesday,
	thursday,
	friday,
	saturday
}

void message(Element? e, String bgcolor, String fgcolor, String text) async
{
	if(e == null)
		return;

	final errw = DivElement();
	errw.classes.add("box");
	errw.style.backgroundColor = bgcolor;
	errw.style.textAlign = "center";
	errw.style.color = fgcolor;
	errw.style.marginTop = "var(--useless-gap)";

	errw.style.fontSize = "13px";
	errw.innerText = text;

	e.parent!.children.add(errw);
	await Future.delayed(Duration(seconds: 3));
	errw.remove();
}

int calc_price(days dayow, int age, String? discount)
{
	int price = 0;

	print("dayow: $dayow");
	print("age: $age");
	print("discount: $discount");


	if(dayow == days.saturday || dayow == days.sunday)
		price = 10;
	else
	{
		if(dayow == days.friday && discount == "FREEFRIDAY")
			price = 0;
		else if(age <= 18)
			price = 5;
		else
			price = 10;
	}
	

	return price;
}

void maketicket(days dayow, int age, int price)
{
	DivElement? ticket = querySelector("#ticket-body")
		as DivElement;

	if(ticket == null)
		return;


	ticket.innerText = """
	Day: ${dayow.toString().split('.').last}
	Age: $age
	Price: $price""";
}

void postbutton_click(Event? ev)
{
	final SelectElement? dayow_input = querySelector("#dayow-input")
		as SelectElement;

	final NumberInputElement? age_input = querySelector("#age-input")
		as NumberInputElement;

	final TextInputElement? discount_input = querySelector("#discount-input")
		as TextInputElement;

	/*    seriously fuck this made-up "null-safety"
	 * i would genuinely take nine hours of segfault debugging over
	 * having to bloat my code to earn the compiler's trust */
	final String? dayow_fuckdart = dayow_input!.value;
	final String? age_fuckdart = age_input!.value;

	if(dayow_fuckdart == null || age_fuckdart == null)
	{
		print("err");
		return;
	}
	else
	{
		int dayow;
		int age;
		try
		{
			dayow = int.parse(dayow_fuckdart);
			age = int.parse(age_fuckdart);

			int price = calc_price(days.values[dayow], age,
				discount_input!.value);

			maketicket(days.values[dayow], age, price);
		}
		on FormatException
		{
			message(age_input, "var(--cat-red)", "var(--cat-crust)",
				"you know what you've done wrong >:(");
		}

	}
}

int main()
{
	final Element? postbutton = querySelector("#postbutton");

	postbutton!.onClick.listen(postbutton_click);

	return 0;
}

