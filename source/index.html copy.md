---
title: Beds2B Rewards - API Reference

language_tabs: # must be one of https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
  - Ayuda

toc_footers:
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

includes:
  - errors

search: true

code_clipboard: true

meta:
  - name: description
    content: Documentation for the Kittn API
---

# Automatización (v.1.0)

## ¿En qué consiste?

Consiste en un proceso automatizado para la verificación y actualización de los estados de las reservas en colaboración con el PMS de nuestros clientes.

En intervalos programados, Beds2B Rewards, enviará al PMS la información de aquellas reservas pendientes de procesar. El PMS deberá entonces procesar las reservas y proporcionar una respuesta, que incluya la información actualizada sobre el estado de las reservas, así como cualquier motivo relevante en caso de actualización del estado. 

Una vez recibida la respuesta del PMS, nuestro sistema, procesará la respuesta del PMS y actualiza automáticamente la información en nuestro sistema. 

Este proceso asegura que los agentes no tendrán que esperar a que sus reservas se procesen automáticamente y podrán obtener sus recompensas de manera inmediata.

## ¿Cómo empezar?

Para empezar deberá ponerse en contacto con nuestro soporte comercial a través de la sección contacto de <a href='https://www.beds2brewards.com/'>https://www.beds2brewards.com/</a>

### Necesitara:

* Desarrollar una API que cumpla las especificaciones descritas en los apartados siguientes.
* Proporcionarnos la URL de dicha API
* Realizar el mapeo de los Hoteles, Canales, Habitaciones y Regímenes en el Back-Office de Beds2B Rewards.

## Integración

> JSON con el modelo de la RQ que se hace al PMS del cliente:

```json
[
  {
    "Id": "00000000-0000-0000-0000-000000000000",
    "ClientId": "100",
    "Name": "HotelBrand & SPA Hotel",
    "Category": 4,
    "RoomsNumber": 500,
    "TimeZoneInfo": null,
    "Bookings": [
      {
        "Id": "00000000-0000-0000-0000-000000000000",
        "OwnLocator": "",
        "BookingLocator": "BOOKING-LOCATOR-123",
        "BookingOrigin": 1,
        "TourOperator": {
          "Id": "00000000-0000-0000-0000-000000000000",
          "ClientId": "234",
          "Name": "Tour Operator Name"
        },
        "BookingStatus": 3,
        "StatusReason": "",
        "CheckIn": "2023-04-02T00:00:00",
        "CheckOut": "2023-04-07T00:00:00",
        "Rooms": [
          {
            "Id": "00000000-0000-0000-0000-000000000000",
            "ClientId": "DBL",
            "Description": "Double",
            "RateId": null,
            "RateDescription": null,
            "Meal": {
              "Id": "00000000-0000-0000-0000-000000000000",
              "ClientId": "AI",
              "Description": "All Included"
            },
            "AdultsNumber": 0,
            "AdultsAges": null,
            "ChildsNumber": 0,
            "ChildsAges": null,
            "Price": null
          }
        ],
        "TotalPrice": 0,
        "AssignedReward": 0,
        "Holder": {
          "Name": "John",
          "Surname": "Doe",
          "SecondSurname": "Doe",
          "Email": null,
          "Phone": null
        }
      }
    ],
    "CrossSellings": null
  }
]
```


El proceso de automatización enviará al PMS todas las reservas que se encuentren en los estados:

* <strong>PEN</strong>: Pendiente
* <strong>REG</strong>: Regularizada

<aside class="notice">
  Atención — Toda reserva que se encuentre en estado final es descartado por la automatización. Además, la automatización descartará siempre las duplicidades debiendo ser estas validadas manualmente.
</aside>

El modelo que se enviará contiene la siguiente información:


| Campo | Tipo | Descripción |
|-------------------------------|--------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ID | Guid | ID del Hotel en Rewards |
| ClientId  | String | ID del Hotel en el PMS  |
| Name  | String | Nombre del hotel |
| Category  | Int  | Categoría del Hotel |
| RoomsNumber | Int  | Número de habitaciones del hotel |
| TomeZoneInfo  | Null | No se usa actualmente |
| Bookings  | List<Booking>| Listado de reservas del hotel  |
| Bookings.Id | Guid | ID de la reserva en Rewards  |
| Bookings.OwnLocator | String | Localizador en el PMS |
| Bookings.BookingLocator | String | Localizador introducido por el agente en Rewards |
| Bookings.BookingOrigin  | Int  | Siempre llegará con 1. En las reservas del sistema antiguo podía valer 0 y se refería a aquellas reservas realizadas por canal de venta directa. |
| Bookings.TourOperador | Object | Nodo con los datos del Tour Operador |
| Bookings.TourOperador.Id  | Guid | ID en Rewards  |
| Bookings.TourOperador.ClientId| String | ID del TTOO en el PMS |
| Bookings.TourOpreador.Name | String | Nombre del Tour Operador |
| Bookings.BookingStatus  | Int  | Indica el estado en el que se encuentra la reserva en Rewards (ver tabla inferior). Debe actualizarse por el nuevo estado (ver tabla inferior) en caso de ser necesario. |
| Bookings.StatusReason | String | Indica el motivo por el que se realizó el cambio de estado. Ver tabla inferior para conocer valores aceptados. |
| Bookings.CheckIn  | DateTime | Fecha de entrada |
| Bookings.CheckOut | DateTime | Fecha de salida |
| Bookings.Rooms  | List Object | Contiene el listado de habitaciones asociados a la reserva  |
| Bookings.Rooms.Id | Guid | ID del tipo de habitación en Rewards |
| Bookings.Rooms.ClientId | String | ID del tipo de habitación en el PMS |
| Bookings.Rooms.Description  | String | Nombre de la habitaci&oacute;n |
| Bookings.Rooms.RateId | Null | Actualmente no se informa. |
| Bookings.Rooms.RateDescription| Null | Actualmente no se informa. |
| Bookings.Rooms.Meal | Object | Contiene los datos del régimen.  |
| Bookings.Rooms.Meal.Id  | Guid | ID del Régimen en Rewards |
| Bookings.Rooms.Meal.ClientId  | String | ID del régimen en el PMS |
| Bookings.Rooms.Meal.Description | String | Descripción del régimen
| Bookings.Rooms.AdultsNumber | Int | Actualmente no se informa.
| Bookings.Rooms.AdultsAges | Null | Actualmente no se informa.
| Bookings.Rooms.ChildsNumber | Int | Actualmente no se informa.
| Bookings.Rooms.ChildsAges | Null | Actualmente no se informa.

<aside class="notice">
  Atención — La actualización de cualquier otro atributo será descartado. Es importante <strong>NO</strong> alterar ningún campo <code>Id</code>.
</aside>


> JSON con el modelo de la RS que debe devolver el PMS a la automatización:

```json
[
  {
    "Id": "00000000-0000-0000-0000-000000000000",
    "ClientId": "100",
    "Name": "HotelBrand & SPA Hotel",
    "Category": 4,
    "RoomsNumber": 500,
    "TimeZoneInfo": null,
    "Bookings": [
      {
        "Id": "00000000-0000-0000-0000-000000000000",
        "OwnLocator": "MY-BOOKING-LOCATOR-123",
        "BookingLocator": "BOOKING-LOCATOR-123",
        "BookingOrigin": 1,
        "TourOperator": {
          "Id": "00000000-0000-0000-0000-000000000000",
          "ClientId": "234",
          "Name": "Tour Operator Name"
        },
        "BookingStatus": 5,
        "StatusReason": "WRONG_DATA",
        "CheckIn": "2023-04-02T00:00:00",
        "CheckOut": "2023-04-07T00:00:00",
        "Rooms": [
          {
            "Id": "00000000-0000-0000-0000-000000000000",
            "ClientId": "DBL",
            "Description": "Double",
            "RateId": null,
            "RateDescription": null,
            "Meal": {
              "Id": "00000000-0000-0000-0000-000000000000",
              "ClientId": "AI",
              "Description": "All Included"
            },
            "AdultsNumber": 0,
            "AdultsAges": null,
            "ChildsNumber": 0,
            "ChildsAges": null,
            "Price": null
          }
        ],
        "TotalPrice": 0,
        "AssignedReward": 0,
        "Holder": {
          "Name": "John",
          "Surname": "Doe",
          "SecondSurname": "Doe",
          "Email": null,
          "Phone": null
        }
      }
    ],
    "CrossSellings": null
  }
]
```

Una vez el PMS reciba la petición deberá procesar las reservas en base a su criterio y modificar los campos <code>BookingStatus</code>, <code>StatusReason</code> y <code>OwnLocator</code> de cada reserva enviada devolviendo el resto del modelo exactamete igual. 

  * <code>BookingStatus</code>: Será uno de los posibles estados de la reserva.
  * <code>StatusReason</code>: En caso de que el cambio de estado sea <strong>CAN</strong>, <strong>DUP</strong> o <strong>REJ</strong> se puede indicar el motivo del estado.
  * <code>OwnLocator</code>: Indicar el localizador en el PMS.

Los valores para <code>StatusReason</code> válidos son:
   
* <strong>BAD_REQUEST</strong>: Úsalo cuando necesites especificar que la petición que te ha enviado la automatización es incorrecta.
* <strong>BAD_REQUEST_INVALID_HOTEL_CODES</strong>: Úsalo cuando necesites especificar que la petición que te ha enviado la automatización es incorrecta porque alguno de los códigos de hotel no han venido informados.
* <strong>NOT_FOUND</strong>: Indica que la reserva no se ha encontrado en el PMS. Por lo general una reserva puede tardar en llegar al PMS con lo que te recomendamos que cuando se de el caso dejes la reserva con el estado de <strong>PEN</strong> para que la automatización la procese de nuevo más adelante.
* <strong>WRONG_DATA</strong>: Indica que la reserva contiene datos incorrectos.
* <strong>WRONG_DATA_INVALID_DATES</strong>: Indica que la reserva se ha encontrado pero las fechas no se corresponden con las del PMS.
* <strong>WRONG_DATA_INVALID_ROOM_TYPE</strong>: Indica que la reserva se ha encontrado pero alguno de los tipos de habitación no son válidos.
* <strong>WRONG_DATA_INVALID_MEAL_TYPE</strong>: Indica que la reserva se ha encontrado pero alguno de los regímenes no son válidos.
* <strong>WRONG_DATA_INVALID_HOTEL</strong>: Indica que la reserva se ha encontrado pero el código de hotel no es válido


### Posibles estados de las reservas

* <strong>0 - CAN</strong>: Cancelada.
* <strong>1 - DUP</strong>: Duplicada. Indica que ya existe una reserva igual en el sistema.
* <strong>2 - INC</strong>: Incompleta.
* <strong>3 - PEN</strong>: Pendiente. Indica que la reserva se ha introducido en el sistema pero está pendiente de regularizarse.
* <strong>4 - REG</strong>: Regularizada. Indica que la reserva existe, es váldia, pero su check-out aún no se ha producido.
* <strong>5 - REJ</strong>: Rechazado. Indica que por algún motivo la reserva ha sido rechazada. Por ejemplo, si los datos que ha introducido no son válidos.
* <strong>6 - VAL</strong>: Validada. Indica que la reserva existe, es válida y su check-out ya se ha producido.

<aside class="success">
Recuerda — Solo las reservas regularizadas y validadas generan una recompensa al agente pero el agente no podrá hacer uso del importe de la recompensa hasta que la reserva se marque como validada.
</aside>

# Volcado de reservas (v.1.0)
## Cómo funciona
## Petición
## Respuesta

> To authorize, use this code:

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
```

```shell
# With shell, you can just pass the correct header with each request
curl "api_endpoint_here" \
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
```

> Make sure to replace `meowmeowmeow` with your API key.

Kittn uses API keys to allow access to the API. You can register a new Kittn API key at our [developer portal](http://example.com/developers).

Kittn expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: meowmeowmeow`

<aside class="notice">
You must replace <code>meowmeowmeow</code> with your personal API key.
</aside>

# Kittens

## Get All Kittens



This endpoint retrieves all kittens.

### HTTP Request

`GET http://example.com/api/kittens`

### Query Parameters

Parameter | Default | Description
--------- | ------- | -----------
include_cats | false | If set to true, the result will also include cats.
available | true | If set to false, the result will include kittens that have already been adopted.

<aside class="success">
Remember — a happy kitten is an authenticated kitten!
</aside>

## Get a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.get(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.get(2)
```

```shell
curl "http://example.com/api/kittens/2" \
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.get(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "name": "Max",
  "breed": "unknown",
  "fluffiness": 5,
  "cuteness": 10
}
```

This endpoint retrieves a specific kitten.

<aside class="warning">Inside HTML code blocks like this one, you can't use Markdown, so use <code>&lt;code&gt;</code> blocks to denote code.</aside>

### HTTP Request

`GET http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to retrieve

## Delete a Specific Kitten

```ruby
require 'kittn'

api = Kittn::APIClient.authorize!('meowmeowmeow')
api.kittens.delete(2)
```

```python
import kittn

api = kittn.authorize('meowmeowmeow')
api.kittens.delete(2)
```

```shell
curl "http://example.com/api/kittens/2" \
  -X DELETE \
  -H "Authorization: meowmeowmeow"
```

```javascript
const kittn = require('kittn');

let api = kittn.authorize('meowmeowmeow');
let max = api.kittens.delete(2);
```

> The above command returns JSON structured like this:

```json
{
  "id": 2,
  "deleted" : ":("
}
```

This endpoint deletes a specific kitten.

### HTTP Request

`DELETE http://example.com/kittens/<ID>`

### URL Parameters

Parameter | Description
--------- | -----------
ID | The ID of the kitten to delete

