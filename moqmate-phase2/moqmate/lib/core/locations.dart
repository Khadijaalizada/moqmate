/// Supported countries and cities. Extend this map to add markets.
/// Group purchases are always scoped to a single country (and preferably city).
const Map<String, List<String>> supportedLocations = {
  'Bangladesh': ['Dhaka', 'Chattogram', 'Khulna', 'Rajshahi', 'Sylhet'],
  'India': ['Mumbai', 'Delhi', 'Kolkata', 'Chennai', 'Bengaluru'],
  'Pakistan': ['Karachi', 'Lahore', 'Islamabad', 'Faisalabad'],
  'United Arab Emirates': ['Dubai', 'Abu Dhabi', 'Sharjah'],
  'Saudi Arabia': ['Riyadh', 'Jeddah', 'Dammam'],
  'Turkey': ['Istanbul', 'Ankara', 'Izmir'],
  'Nigeria': ['Lagos', 'Abuja', 'Kano'],
  'United Kingdom': ['London', 'Manchester', 'Birmingham'],
  'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston'],
};
