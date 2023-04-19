---
title: Beds2B Rewards - API Reference

language_tabs: # must be one of https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
  - Ayuda

toc_footers:
  - <a href='https://github.com/slatedocs/slate'>Documentation Powered by Slate</a>

includes: false

search: false

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

Para empezar deberá ponerse en contacto con nuestro soporte comercial a través de la sección contacto de <a href='https://www.beds2brewards.com/'>https://www.beds2brewards.com/</a> e indicar que quiere realizar la activación del proceso de automatización en su sistema.

### Necesitara:

* Desarrollar una API que cumpla las especificaciones descritas en los apartados siguientes.
* Proporcionarnos la URL de dicha API
* Realizar el mapeo de los Hoteles, Canales, Habitaciones y Regímenes en el Back-Office de Beds2B Rewards.

## Integración


El proceso de automatización enviará al PMS todas las reservas que se encuentren en los estados:

* <strong>PEN</strong>: Pendiente
* <strong>REG</strong>: Regularizada

<aside class="notice">
  Atención — Toda reserva que se encuentre en estado final es descartado por la automatización. También serán descartadas siempre las duplicidades debiendo ser estas validadas manualmente.
</aside>

La API de automatización enviará al PMS una petición que contiene la siguiente información:

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

Una vez el PMS reciba la petición deberá procesar las reservas en base a su criterio y modificar los campos <code>BookingStatus</code>, <code>StatusReason</code> y <code>OwnLocator</code> de cada reserva que se le ha enviado devolviendo el resto del modelo <strong>exactamente igual</strong>. Donde:

  * <code>BookingStatus</code>: Será uno de los posibles estados de la reserva.
  * <code>StatusReason</code>: En caso de que el cambio de estado sea <strong>CAN</strong>, <strong>DUP</strong> o <strong>REJ</strong> se puede indicar el motivo del estado.
  * <code>OwnLocator</code>: Indicar el localizador en el PMS.

<aside class="warning">
  Atención — La actualización de cualquier otro atributo será descartado. Es importante <strong>NO</strong> alterar ningún campo <code>Id</code>.
</aside>

Los valores para <code>BookingStatus</code> válidos son los que a contiuación se detallan (columna Código):

Código | ISO | Descripción
---------- |---------- | -------
0 | CAN | Cancelada.
1 | DUP | Duplicada. Indica que ya existe una reserva igual en el sistema..
2 | INC | Incompleta.
3 | PEN | Pendiente. Indica que la reserva se ha introducido en el sistema pero está pendiente de regularizarse.
4 | REG | Regularizada. Indica que la reserva existe, es váldia, pero su check-out aún no se ha producido.
5 | REJ | Rechazado. Indica que por algún motivo la reserva ha sido rechazada. Por ejemplo, si los datos que ha introducido no son válidos.
6 | VAL | Validada. Indica que la reserva existe, es válida y su check-out ya se ha producido.

<aside class="success">
Recuerda — Solo las reservas regularizadas y validadas generan una recompensa al agente pero el agente no podrá hacer uso del importe de la recompensa hasta que la reserva se marque como validada.
</aside>

Los valores para <code>StatusReason</code> válidos son:

Código | Descripción
---------- | -------
BAD_REQUEST | Úsalo cuando necesites especificar que la petición que te ha enviado la automatización es incorrecta.
BAD_REQUEST_INVALID_HOTEL_CODES | Úsalo cuando necesites especificar que la petición que te ha enviado la automatización es incorrecta porque alguno de los códigos de hotel no han venido informados.
NOT_FOUND | Indica que la reserva no se ha encontrado en el PMS. Por lo general una reserva puede tardar en llegar al PMS con lo que te recomendamos que cuando se de el caso dejes la reserva con el estado de <strong>PEN</strong> para que la automatización la procese de nuevo más adelante.
WRONG_DATA | Indica que la reserva contiene datos incorrectos.
WRONG_DATA_INVALID_DATES | Indica que la reserva se ha encontrado pero las fechas no se corresponden con las del PMS.
WRONG_DATA_INVALID_ROOM_TYPE | Indica que la reserva se ha encontrado pero alguno de los tipos de habitación no son válidos.
WRONG_DATA_INVALID_MEAL_TYPE | Indica que la reserva se ha encontrado pero alguno de los regímenes no son válidos.
WRONG_DATA_INVALID_HOTEL | Indica que la reserva se ha encontrado pero el código de hotel no es válido

# Volcado de reservas (v.1.0)

## ¿En qué consiste?

Beds2B Rewards pone a disposición de sus clientes un WebHook al que enviar la información de las reservas que tiene en su PMS para que los agentes asociados al Rewards no tengan que introducirlas manualmente.

## ¿Cómo empezar?

Para empezar deberá ponerse en contacto con nuestro soporte comercial a través de la sección contacto de <a href='https://www.beds2brewards.com/'>https://www.beds2brewards.com/</a> e indicar que quiere realizar integración con el proceso de descarga de reservas.

Una vez activo se le proporcionará un <code>username</code> y <code>password</code> para que pueda realizar las peticiones al WebHook

## Integración

### HTTP Request

> JSON con el modelo de la RQ que debe enviarse al WebHook:

```json
[
  {
  "clientSecurity": {
    "contractNumber": "your-contract-number",
    "username": "your-username",
    "password": "your-password"
  },
  "bookings": [
    {
      "bookingReference": "locator-001",
      "externalBookingReference": "locator-001-ext",
      "checkIn": "2023-04-17",
      "checkOut": "2023-04-18",
      "name": "John",
      "surname1": "Doe",
      "surname2": "Doe",
      "idEstablishment": "HOTEL-1234",
      "idTtoo": "12345",
      "roomsInfo": [
        {
          "roomId": "SR-12345",
          "regimeId": "AI-1234"
        },
		    {
          "roomId": "DBL-1234",
          "regimeId": "AI-1234"
        }
      ],
      "uaid": "0433345U",
      "imported": false,
      "importedResult": ""
    }
  ]
}
]
```


`POST https://your-beds2b-rewards-client-url/api/Bookings/ImportBookings`

<strong>NOTA</strong>: <code>your-beds2b-rewards-client-url</code> Es la URL que tiene tu Web de Agentes.

### Modelo


El modelo que debe enviarse al WebHook debe contener la siguiente estructura:

| Campo | Tipo | Descripción |
- | - | -
clientSecurity | object | Contendrá las credenciales de cliente
clientSecurity.contractNumber | string | Número del contrato 
clientSecurity.username | string | Nombre de usuario
clientSecurity.password | string | Contraseña
bookings | List Object | Listado de reservas que desean volcarse en el sistema
bookings.bookingReference | string | Localizador del PMS
bookings.externalBookingReference | string | Localizador en el sistema externo (en caso de haberse hecho a través de un canal no directo)
bookings.checkIn | Date | Fecha de entrada (YYYY-MM-DD)
bookings.checkOut | Date | Fecha de salida (YYYY-MM-DD)
bookings.name | string | Nombre del titular de la reserva
bookings.surname1 | string | Primer apellido del titular de la reserva
bookings.surname2 | string | Segundo apellido del titular de la reserva
bookings.idEstablisment | string | Código del Hotel en el PMS (Mapear en Back-Office)
bookings.idTtoo | string | Código del canal de venta en el PMS (Mapear en Back-Office)
bookings.roomInfo | List Object | Listado de habitaciones de la reserva
bookings.roomInfo.roomId | string | Código del tipo de habitación en el PMS (Mapear en el Back-Office)
bookings.roomInfo.regimeId | string | Código del régmen en el PMS (Mapear en el Back-Office)
bookings.uaid | string | Universal Agent ID. El agente puede consultarlo en la web de agentes de Rewards
bookings.imported | boolean | Indica si la reserva se guardó correctamente en Rewards
bookings.importedResult | string | Indica el motivo por el que el volcado de la reserva no se pudo realizar

<aside class="notice">
Recuerda — El número de <code>contractNumber</code> puede consultarse en el Back-Office. 
</aside>

<aside class="notice">
Recuerda — Desde el Back-Office puedes modificar el comportamiento del registro de reservas permitiendo que se añadan reservas duplicadas. Recuerda que aunque se tenga el proceso de automatización activo, la automatización, no validará reservas duplicadas.
</aside>

### HTTP Response

> JSON con el modelo de la RS que devolverá el WebHook en caso de éxito:

```json
[
  {
  "clientSecurity": {
    "contractNumber": "your-contract-number",
    "username": "your-username",
    "password": "your-password"
  },
  "bookings": [
    {
      "bookingReference": "locator-001",
      "externalBookingReference": "locator-001-ext",
      "checkIn": "2023-04-17",
      "checkOut": "2023-04-18",
      "name": "John",
      "surname1": "Doe",
      "surname2": "Doe",
      "idEstablishment": "HOTEL-1234",
      "idTtoo": "12345",
      "roomsInfo": [
        {
          "roomId": "SR-12345",
          "regimeId": "AI-1234"
        },
		    {
          "roomId": "DBL-1234",
          "regimeId": "AI-1234"
        }
      ],
      "uaid": "0433345U",
      "imported": true,
      "importedResult": ""
    }
  ]
}
]
```

> JSON con el modelo de la RS que devolverá el WebHook en caso de error:

```json
[
  {
  "clientSecurity": {
    "contractNumber": "your-contract-number",
    "username": "your-username",
    "password": "your-password"
  },
  "bookings": [
    {
      "bookingReference": "locator-001",
      "externalBookingReference": "locator-001-ext",
      "checkIn": "2023-04-17",
      "checkOut": "2023-04-18",
      "name": "John",
      "surname1": "Doe",
      "surname2": "Doe",
      "idEstablishment": "HOTEL-1234",
      "idTtoo": "12345",
      "roomsInfo": [
        {
          "roomId": "SR-12345",
          "regimeId": "AI-1234"
        },
		    {
          "roomId": "DBL-1234",
          "regimeId": "AI-1234"
        }
      ],
      "uaid": "0433345U",
      "imported": false,
      "importedResult": "DUPLICATED"
    }
  ]
}
]
```

El WebHook devolverá el mismo modelo actualizando los campos <code>imported</code> y <code>importedResult</code>.

Si <code>imported</code> es <code>true</code> implicará que la reserva se ha registrado correctamente. En caso contrario, indicará que se ha producido algún error a la hora de procesar la reserva.

En caso de que <code>imported</code> sea <code>false</code> se informará el campo <code>importedResult</code> con alguno de los siguientes valores:

| Código | Descripción
- | -
GENERIC_ERROR | Error genérico. Se produjo algún error inesperado por el cuál la reserva no pudo añadirse al sistema.
DUPLICATED | Indica que la reserva ya existe en el sistema. 

<br/>
<br/>
<br/>
<br/>
<br/>
<br/>