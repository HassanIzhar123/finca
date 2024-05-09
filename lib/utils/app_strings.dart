class AppStrings {
  AppStrings._();

  static const appName = 'FincaAPP';
  static const welcome = 'Bienvenido!';
  static const enterEmail = "Ingrese su correo electrónico";
  static const notification = 'Notificación';
  static const loginHere = 'Iniciar sesión aquí';
  static const String login = 'Iniciar sesión';
  static const String dntHaveAccount = 'No tienes una cuenta? Regístrate¿';
  static const String theContinue = 'Continuar con';
  static const didForgetPassword = '¿Olvidaste tu contraseña?';
  static const notificationTitle = 'Notificación Diaria';
  static const notificationMessage = 'Tienes una nueva actividad programada para hoy';
  static const noNotification = "Sin notificaciones";
  static const activities = 'Actividades';
  static const agreement =
      "Al registrarme, acepto los términos y condiciones y la política de privacidad de TediTerritorio";
  static const signup = "Registrarse";
  static const haveAccountSignup = '¿Ya tienes una cuenta? Iniciar sesión';
  static const newFarm = "Nueva Finca";
  static const editFarm = "Editar granja";
  static const addYourProperties = "Agrega tus propiedades aquí";
  static const share = "Compartir";
  static const delete = "Eliminar";
  static const stepOne = "Paso 1 de 4";
  static const stepTwo = "Paso 2 de 4";
  static const stepThree = "Paso 3 de 4";
  static const stepFour = "Paso 4 de 4";
  static const stepOneDescription = "Selecciona la ubicación de la finca";
  static const findLocation = "Buscar Ubicación";
  static const undo = "Deshacer";
  static const cancel = "Cancelar";
  static const closeForm = "Cerrar Formulario";
  static const newPropertySave = "¡Nueva propiedad guardada!";
  static const name = "Nombre*";
  static const size = "Tamaño en Hectareas*";
  static const soilType = "Tipo de Suelo*";
  static const continueText = 'Continuar';
  static const addTheCrops = 'Añadir los cultivos*';
  static const addCrops = 'Añadir cultivo';
  static const newCrop = 'Nuevo Cultivo';
  static const editCrop = 'Editar recorte';
  static const cropName = 'Nombre del Cultivo*';
  static const variety = 'variedad*';
  static const scientificName = 'Nombre Científico*';
  static const seedTime = 'Tiempo de Siembra:';
  static const sowingStatus = 'Estado de Siembra:';
  static const searchScientificName = "Buscar Nombre Científico";
  static const sowingText = "Siembra";
  static const maintenance = "Mantenimiento";
  static const harvest = "Cosecha";
  static const inProgress = 'En progreso';
  static const stepTwoNewFarmDescription = 'Descripción:';
  static const keepText = 'Guardar';
  static const enterPassword = 'Ingrese su contraseña';
  static const selectWhichCrops = 'Seleccionar qué cultivos';
  static const chemicalNameEmpty = "El nombre del químico no puede estar vacío";
  static const amountEmpty = "La cantidad no puede estar vacía";
  static const detailsEmpty = "Los detalles no pueden estar vacíos";
  static const eliminate = 'Eliminar';
  static const selectCrop = 'Select Crop';
  static const cropNotMatching = "Este cultivo no pertenece a esta finca.";
  static const endDateSmallerThanStartDate = "La fecha de fin no puede ser menor que la fecha de inicio";
  static const endDateEqualToStartDate = "La fecha de fin no puede ser igual a la fecha de inicio";
  static const oneDayGap = "Debe haber al menos un día de diferencia entre la fecha de inicio y la fecha de fin";
  static const newActivity = 'Nueva Actividad';
  static const stepOneOfFour = 'Paso 1 de 4';
  static const startDate = '*Fecha de inicio';
  static const startTime = '*Hora de inicio';
  static const allDay = 'Todo el día';
  static const endDate = '*Fecha de finalización';
  static const endTime = '*Hora de finalización';
  static const selectDate = 'Select date';
  static const selectTime = 'Select Time';
  static const List<String> activityTypes = [
    'Insecticida',
    'Fungicida',
    'Bactericida',
    'Herbicida',
    'Fertilizante',
    'Riego',
    'Siembra',
    'Cosecha',
    'Mantenimiento de Equipos',
    'Entrenamientos',
    'Monitoreo de Plagas',
    'Control de Malezas',
    'Preparación del Suelo',
    'Visitas Técnicas',
    'Otro',
  ];
  static const stepsText = ["Sowing", "In Progress", "Harvest"];
}

// class AppStrings {
//   AppStrings._();
//
//   static const appName = 'FincaAPP';
//   static const welcome = 'Welcome';
//   static const enterEmail = "Enter your email";
//   static const notification = 'Notification';
//   static const loginHere = 'Log in here';
//   static const String login = 'Login';
//   static const String dntHaveAccount = 'You do not have an account? Sign up';
//   static const String theContinue = 'The continue with';
//   static const didForgetPassword = 'Did you forget your password?';
//   static const notificationTitle = 'Daily Notification';
//   static const notificationMessage = 'You have a Nueva Actividad scheduled for today.';
//   static const noNotification = "No notification";
//   static const activities = 'Activities';
//   static const agreement = "By registering I agree with the terms and conditions and privacy policy of TediTerritorio";
//   static const signup = "SignUp";
//   static const haveAccountSignup = 'Do you have an account? Login';
//   static const newFarm = "New Farm";
//   static const editFarm = "Edit Farm";
//   static const addYourProperties = "Add your properties here";
//   static const share = "Share";
//   static const delete = "Delete";
//   static const stepOne = "Paso 1 de 4";
//   static const stepTwo = "Step 2 of 4";
//   static const stepThree = "Step 3 of 4";
//   static const stepFour = "Step 4 of 4";
//   static const stepOneDescription = "Select the location of the farm:";
//   static const findLocation = "Find Location";
//   static const undo = "Undo";
//   static const cancel = "Cancel";
//   static const closeForm = "Close Form";
//   static const newPropertySave = "New property saved!";
//   static const name = "*Name";
//   static const size = "*Size in Hectares";
//   static const soilType = "*Soil Type";
//   static const continueText = 'Continue';
//   static const addTheCrops = '*Add the crops';
//   static const addCrops = 'Add crop';
//   static const newCrop = 'New Crop';
//   static const editCrop = 'Edit Crop';
//   static const cropName = '*Crop Name:';
//   static const variety = '*Variety:';
//   static const scientificName = '*Scientific Name:';
//   static const seedTime = 'Seed Time:';
//   static const sowingStatus = 'Sowing Status:';
//   static const searchScientificName = "Search Scientific Name";
//   static const sowingText = "Sowing";
//   static const maintenance = "maintenance";
//   static const harvest = "Harvest";
//   static const inProgress = 'In progress';
//   static const stepTwoNewFarmDescription = 'Description:';
//   static const keepText = 'Keep';
//   static const enterPassword = 'Enter your password';
//   static const selectWhichCrops = 'Select which crops';
//   static const chemicalNameEmpty = "Chemical name cannot be empty";
//   static const amountEmpty = "Amount cannot be empty";
//   static const detailsEmpty = "Details cannot be empty";
//   static const eliminate = 'Eliminate';
//   static const selectCrop = 'Select Crop';
//   static const cropNotMatching = "This crop doesn't belong to this farm";
//   static const endDateSmallerThanStartDate = "'End date cannot be smaller than start date'";
//   static const endDateEqualToStartDate = 'End date cannot be equal to start date';
//   static const oneDayGap = 'There should be at least one day gap between start and end date';
//   static const newActivity = 'Nueva Actividad';
//   static const stepOneOfFour = 'Paso 1 de 4';
//   static const startDate = '*Fecha de inicio';
//   static const startTime = '*Hora de inicio';
//   static const allDay = 'Todo el día';
//   static const endDate = '*Fecha de finalización';
//   static const endTime = '*Hora de finalización';
//   static const selectDate = 'Select date';
//   static const selectTime = 'Select Time';
//   static const List<String> activityTypes = [
//     'Insecticide',
//     'Fungicide',
//     'Bactericide',
//     'Herbicide',
//     'Fertilizer',
//     'Irrigation',
//     'Sowing',
//     'Harvest',
//     'Equipment maintenance',
//     'Trainings',
//     'Pest monitoring',
//     'Weed control',
//     'Soil preparation',
//     'Technical visits',
//     'Other',
//   ];
//   static const stepsText = ["Sowing", "In Progress", "Harvest"];
// }
