package controllers

import javax.inject._

import play.api._
import play.api.mvc._
import io.getquill._
import play.api.libs.json.Json

/**
  *
 * This controller creates an `Action` to handle HTTP requests to the
 * application's home page.
 */
@Singleton
class HomeController @Inject() extends Controller {

  implicit val todosWrites = Json.format[Todos]
  /**
   * Create an Action to render an HTML page with a welcome message.
   * The configuration in the `routes` file means that this method
   * will be called when the application receives a `GET` request with
   * a path of `/`.
   */
  lazy val ctx = new JdbcContext[MySQLDialect, SnakeCase]("ctx")
  import ctx._
  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

//  def getMessage = Action {
//    val q = quote(query[Personas].map(_.nombre))
//    Ok(ctx.run(q).toString())
//  }

  def getMessage = Action {
    val q = quote(query[Todos])
    Ok(Json.toJson(ctx.run(q)))
  }

  def completeTask(id: Long) = Action {
    val q = quote(query[Todos].filter(_.id == lift(id)).update(_.completed -> true))

    ctx.run(q)
    Ok(Json.toJson(id))
  }


  def insert= Action { request =>
    def asd(task: String) = {
      val newTodo: Todos = Todos(0L, task, false)
      val q = quote(query[Todos].insert(lift(newTodo)).returning(_.id))
      Ok(Json.toJson(newTodo.copy(id = run(q))))
   }
    val task =
    request.body.asJson.flatMap {
    json =>
      (json \ "task").asOpt[String]
  }
    task match {
    case Some(a) =>  asd(a)
    case None => BadRequest("Some value must be provided")
    }
}

def rawSqlQuery(task: String) = Action {

  def q(task: String) = quote {
    infix"select * from todos where task = ${lift(task)}".as[Query[Todos]]
  }

  Ok(run(q(task)).foldLeft("Tareas encontradas:")((acc, todo) => acc + todo.id + " task: " + todo.task+ " completada: " + todo.completed))
}

//  case class Personas(id: Long, nombre: String, edad: Int)
case class Todos(id: Long, task: String, completed: Boolean)
}

