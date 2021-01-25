List<String> nigeriaStates = [
  "Abia",
  "Adamawa",
  "Akwa Ibom",
  "Anambra",
  "Bauchi",
  "Bayelsa",
  "Benue",
  "Borno",
  "Cross River",
  "Delta",
  "Ebonyi",
  "Edo",
  "Ekiti",
  "Abuja",
  "FCT",
  "Enugu",
  "Gombe",
  "Imo",
  "Jigawa",
  "Kaduna",
  "Kano",
  "Katsina",
  "Kebbi",
  "Kogi",
  "Kwara",
  "Lagos",
  "Nasarawa",
  "Niger",
  "Ogun",
  "Ondo",
  "Osun",
  "Oyo",
  "Plateau",
  "Rivers",
  "Sokoto",
  "Taraba",
  "Yobe",
  "Zamfara",
];
List<String> providerTypes = [
  "Hospital",
  "Gym",
  "Spa",
  "Optical Centre",
  "Pharmacy",
  "Dental Clinic",
  "Laboratory"
];
List<String> providerTypess = [
  "All",
  "Hospital",
  "Gym",
  "Spa",
  "Optical Centre",
  "Pharmacy",
  "Dental Clinic",
  "Laboratory"
];

String greeting() {
  var hour = DateTime.now().hour;
  if (hour < 12) {
    return 'Good Morning';
  }
  if (hour < 17) {
    return 'Good Afternoon';
  }
  return 'Good Evening';
}

String plurals(String val) {
  if (val == "All") {
    return "Providers";
  } else if (val == "Pharmacy") {
    return "Pharmacies";
  } else if (val == "Laboratory") {
    return "Laboratories";
  }
  return val + "s";
}
