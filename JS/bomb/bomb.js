
    function Con_IO(inp, outp){
		this.inp = [false,false]
		this.outp = [false,false,false,false];
		this.is_on = false;
		function check(array){
			var type_check = array.some(function(value){
							var check;
							Con_IO.prototype.type.forEach(function(type){
								check = (type === value) ? true:false;
								});
							return check;
						});
			return type_check;
		}
		function assign (self, obj, string){
			if(Array.isArray(obj)){
					obj.forEach(function(val){
					var type_check;
					if(val['type']){
						type_check = check(val['type']);
					}
					if(type_check){                    
						self[string].push(val);
						if(!self[string][0]){
							self[string].shift();
						}
					}
					})
			}
			else if(typeof obj === 'object'){
				Object.keys(obj).forEach(function (val){
					var type_check;
					if(obj[val]['type']){
					type_check = check(obj[val]['type']);
					}
					if(type_check){
						self[string].push(obj[val]); 
						if(!self[string][0]){
							self[string].shift();
						}
					}
				});
			}
		}
		if(inp){
			assign(this, inp, 'inp');
		}
		if(outp){
			assign(this, outp, 'outp');
		}
	}
	Con_IO.prototype = Object.create(Object.prototype);
	Con_IO.prototype.type = (function() {
		var arr = ['Con_IO'];
		return arr;
	})()
	Con_IO.prototype.constructor = new Con_IO();
	Con_IO.prototype.Update = function (callback){
		if(typeof callback === 'function'){
			this.is_on = callback();
		}
		   this.outp.forEach(function(val){
				if(val != false){
					val.Update();
				}
		   }, this);
	}

	function Switch(is_on, connectors){
		connectors = connectors || [[],[]];
		Con_IO.call(this, connectors[0], connectors[1]);
		this.is_on = is_on;
	}

	Switch.prototype = Object.create(Con_IO.prototype);
	Switch.prototype.constructor = new Switch();
	Switch.prototype.type = (function(){
		var arr = Con_IO.prototype.type.slice();
		arr.push('Switch');
		return arr;
	})()

	function Gate(type, connectors){
		var types = [['And', this.And],
					['Or', this.Or],
					['Not', this.Not],
                    ['Nand: this.Nand'],
                    ['Nor', this.Nor],
                    ['Exor', this.Exor],
                    ['Exnor', this.Exnor]];
		this.gate_type = types[type];
		connectors = connectors || [[],[]];
		Con_IO.call(this, connectors[0], connectors[1]);
	}

	Gate.prototype = Object.create(Con_IO.prototype);
	Gate.prototype.constructor = new Gate();
	Gate.prototype.type = (function(){
		var arr = Con_IO.prototype.type.slice();
		arr.push('Gate');
		return arr;
	})()
	Gate.prototype.And = function(){
		var total = 0;
        var f = 0;
        this.inp.forEach(function(val){
            if(val){
                if(val.is_on){
                    total++;
                }
            }
            else{
                f++;
            }
        });
        var needed = this.inp.length - f;
        return total === needed;
	}

	Gate.prototype.Or = function(){
		for(var i in this.inp){
            if(this.inp[i]){
    			if(this.inp[i].is_on){
    				return true;
    			}
            }
		}
		return false;
	}

	Gate.prototype.Not = function(){
		var needOne= [];
		this.inp.forEach(function(val){
    	    if(val){
                needOne.push(val.is_on);
    	    }
		});
        return !(needOne.shift());
	}
    Gate.prototype.Nand = function(){
        return !(this.And());
    }
    Gate.prototype.Nor = function(){
        return !(this.Or());
    }
    
    Gate.prototype.Exor = function(){
        var i = 0;
        this.inp.forEach(function(val){
            console.log(val)
            if(val){
                if(val.is_on){
                    i++;
                }
            }
        })
        return i === 1;
    }
    
    Gate.prototype.Exnor = function(){
        return !(this.Exor());
    }
	Gate.prototype.Update = function (){
		var self = this;
		var type = this.gate_type[1];
		Con_IO.prototype.Update.call(self, function(){
		   return (type.call(self));
		});
	}

	function Bomb(type, time, connectors){
		Gate.call(this, type, connectors );
		this.time = time;
		this.remaining = time;
	}
	Bomb.prototype = Object.create(Gate.prototype);
	Bomb.prototype.constructor = new Bomb();
	Bomb.prototype.type = (function(){
		var arr = Gate.prototype.type.slice();
		arr.push('Bomb');
		return arr;
	})()
	Bomb.prototype.Timer = function(){
		var self = this;
		var intID = setInterval(function(){
			if(self.remaining < 0 || !self.is_on||self.remaining ===
			"NaN"){            
				clearInterval(intID);
				return;
			}
			self.remaining--;
			
		},1000);
	}
    
function switch_gate(gate_type){
    var inp = [];
    var outp = [];
    var connectors = [inp,outp];
    var s1 = new Switch(true);
    var s2 = new Switch(true);
    inp.push(s1);
    inp.push(s2);
    var g = new Gate(gate_type, connectors);
    s1.outp[0]=g;
    s2.outp[0]=g;
    switch(gate_type){
        case 0:
        case 1:
        break;
        case 2:{
            g.inp[1] = false;
            s1.is_on = false;
        }
        break;
        case 3:{
            s1.is_on = false;
        }
        break;
        case 4:{
            s1.is_on = false;
            s2.is_on = false;
        }
        break;
        case 5:{
            s1.is_on = false;
        }
        break;
        case 6:
        break;
        default:
            return false;
        
    }
    g.Update();
    return {
        id: undefined,
        is_on: function(){
            g.Update();
            return g.is_on;
        },
        change_in: function(i, obj){
             var check = obj.type.some(function(val){
                 var has;
                 Gate.prototype.type.forEach(function(value){
                     if(value === val){
                         has = true;
                     }
                 })
                 return true;
             });
             if(check){
                 g.inp[i] = obj;
             }
             g.Update();
        },
        _switch_out: function(i, obj){
            if(obj){
                var sw = g.inp[i];
                var check = obj.type.some(function(val){
                    return (val === 'Gate' || val === 'Bomb');
                });
                if(check){
                    sw.outp.unshift(obj);
                }
            }
        },
        _switch: function (i, value){
            var sw = g.inp[i];
            if(sw){
                if(value === true || value === false){
                    sw.is_on = value;
                    sw.Update();
                }
                return sw.is_on;
            }
        },
        output: function(){return g.outp},
        add_out: function(obj){
            var check = obj.type.some(function(val){
                return (val === 'Gate' || val === 'Bomb');
            })
            if(check){
                g.outp.unshift(obj);
            }
            g.Update();
        },
        get_items: function(){
            return [g, g.inp[0], g.inp[1]];
        },
        out: g,
    }
    
}

function gate_to_gate(in_gates, bomb, time){
    if(!in_gates){
        return false;
    }
    var eligible_types = function(b1, b2){
        var pos = [];
        var s1 = new Switch(b1);
        var s2 = new Switch(b2);
        var logic = Gate.prototype;
        var all = [logic.And, logic.Or, logic.Not, logic.Nand, 
            logic.Nor, logic.Exor, logic.Exnor];
        all.forEach(function (fun, i){
            if(fun.call(new Gate(i, [[s1,s2],[]]))){
                pos.push(i);
            }
        });
        return pos;
    }
    var t = eligible_types(in_gates[0].is_on, in_gates[1].is_on);
    var index = Math.floor(Math.random()*t.length);
    gate_type = t[index];
    var out_gate;
    
    if(bomb){
        out_gate = new Bomb(gate_type, time, [in_gates,[]]);
    }
    else{
        out_gate = new Gate(gate_type, [in_gates,[]])
    }
    
    return {
        add_out: function(obj){
            var check = obj.type.forEach(function(val){
                return (val === 'Bomb' || val ==='Gate');
            });
            if(check){
                out_gate.outp.unshift(val);
                out_gate.Update();
            }
        },
        output: function(){return out_gate.outp;},
        change_in: function(i, obj){
             var check = obj.type.some(function(val){
                 var has;
                 Gate.prototype.type.forEach(function(value){
                     if(value === val){
                         has = true;
                     }
                 })
                 return true;
             });
             if(check){
                 out_gate.inp[i] = obj;
             }
             out_gate.Update();
        },
        is_on: function(){
            out_gate.Update();
            return out_gate.is_on;
        },
        out: out_gate,
    }
}





