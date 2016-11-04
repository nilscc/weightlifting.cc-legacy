import $          = require("jquery");
import handlebars = require("handlebars");

interface Workout {
  workoutId: number,
  workoutDate: Date,
  workoutExercises: WorkoutExercise[],
}

interface WorkoutExercise {
  workoutExerciseId: number,
  workoutExerciseName: string,
  workoutExerciseSets: WorkoutSet[],
}

interface WorkoutSet {
  workoutSetId: number,
  workoutSetReps: number,
  workoutSetWeight: Rational,
}

interface Rational {
  denominator: number,
  numerator: number,
}

function main() {

  let src = $("#workout-template").html();
  let template = handlebars.compile(src);

  handlebars.registerHelper('weight', function(weight:Rational) {
    return (weight.numerator / weight.denominator).toString() + " kg";
  });

  $.get("/api/training/workouts", function (data) {
    let workouts:Workout[] = JSON.parse(data);
    for (let workout of workouts) {
      $("main .workouts").html(template(workout));
    }
  });

}

export = main;
