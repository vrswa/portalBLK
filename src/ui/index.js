

var Estilos= "cerulean chubby cosmo cyborg darkly flatly journal lumen paper readable sandstone simplex slate solar spacelab superhero united yeti"
              .split(' ');
var app_style= {};

function setTheme(t) {
  var st= document.getElementById("tema");
  st.href='/node_modules/semantic-ui-forest-themes/semantic.'+t+'.min.css';
}

//COMPONENTE DE LOGIN
uiLogin = MkUiComponent (function uiLogin(my){
  my.componentWillMount = function () {
    var body = document.getElementsByTagName('body')[0];
    body.style.backgroundImage = 'url(fondo.jpg)';
  }

  my.render = function(){
    return (
      h(Grid,{textAlign:'center', style:{ height: '100vh' }, verticalAlign:'middle'},
        h(Grid.Column, {style: {maxWidth: 450}}, 
          h(Header, {as:'h2', color:'teal', textAlign:'center',style: {'font-size':'25px'}},
            //<Image src='/logo.png' /> Log-in to your account
            h(Image,{src:'logoGrande.jpg',style: {'height':'60px!important'}},),
            "Log-in to your account",
          ),
          h(Form,{size:'large'},
            h(Segment,{stacked:true},
              h(Form.Input,{fluid:true, icon:'user', iconPosition:'left', placeholder:'E-mail address'}),
              h(Form.Input,{ fluid:true, icon:'lock',iconPosition:'left',placeholder:'Password',type:'password'}),
              h(Button,{color:'blue', fluid:true,size:'large',onClick: () =>preactRouter.route("/menu")},"Login")
            )
          )  
        )
      )
    )
  }
});

uiMenu= MkUiComponent(function uiMenu(my) {
  handleItemClick = (e, { name }) => my.setState({ activeItem: name }) 
  my.state= {
    activeItem: 'itemA'
  }

  my.render= function (props, state) {
    return (
      h(Menu,{item:true,stackable:true},
        h(Menu.Item,{name: 'itemA',onClick: () => handleItemClick },"Consulta"),
        h(Menu.Item,{name: 'itemB',onClick: () => handleItemClick},"Reportes"),
        h(Dropdown, {name: 'itemC',onClick: () => handleItemClick,item:true, text:'Nuestro Menu'},
          h(Dropdown.Menu,{},
            h(Dropdown.Item,{},'item A'),
            h(Dropdown.Item,{},'item B'),
            h(Dropdown.Item,{},'item C')  
          )
        ),
        h(Menu.Menu,{position:'right'},
          h(Menu.Item,{},
            h(Label, {as:'a',color:'yellow' ,image: true},
              h('img',{'src':'https://react.semantic-ui.com/images/avatar/small/christian.jpg'}),
              'Bienvenido Tomas',
              h(Label.Detail,{},'Inspector Aduanero')
            )
          ),
          h(Menu.Item,{},
            h(Button, {negative:true,onClick: () =>preactRouter.route("/")},"salir" ),
          )
        )
      )  
		);
  }
});


//RUTA DE PREACT ROUTE
Rutas= {
  "/":{cmp: uiLogin},
  "/menu": {cmp: uiMenu}
}
//-----------------------------------------------------------------------------
App= MkUiComponent(function App(my) {
  my.render= function (props, state) {
    return (
      h(Container, {id:'app'},
				h(preactRouter.Router, {history: History.createHashHistory()},
					Object.entries(Rutas).map( ([k,v]) => 
						h(v.cmp, {path: k, ...v}) //A: el componente para esta ruta
					)
				), //A: la parte de la app que controla el router
				//VER: https://github.com/preactjs/preact-router
			)
		);
  }
});
//-----------------------------------------------------------------------------


setTheme('readable');
render(h(App), document.body);
//A: estemos en cordova o web, llama a la inicializacion
