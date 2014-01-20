looks_like = {
  'Looks like ## What do you see?' => {
    'Smoke' => {
      'Black ## When and where do you see black smoke?' => {
        'It comes from the exhaust while driving ## Is the air filter dirty?' => {
          ['Yes', 'I don\'t know'] =>
            'Replace the air filter',
          'No' =>
            'If the air filter looks good, there might be an issue with a fuel injection sensor'
        },
        'Right after starting the engine' =>
          'The engine sensor couls be bad'
      },
      'White ## When and where do you see white smoke?' => {
        'It comes from the exhaust while driving ## Do you notice white smoke even after the engine has warmed up?' => {
          'Yes' =>
            'It is likely you have a blown head gasket. You\'ll need a new head gasket.',
          'No' =>
            'This is normal and just condensation steaming off'
        },
        'When it\'s very cold outside' =>
          'This is normal and just condensation steaming off if it goes away after it warms up',
        'Right after starting the engine, then it stops' =>
          'The engine sensor could be bad'
      },
      'Blue ## What other symptoms are you noticing?' => {
        'The engine has less power when going up hills' =>
          'The piston rings are probably bad',
        'There is blue smoke during acceleration' =>
          'The valve system seals may be bad'
      }
    },
    'Poor gas mileage ## Are the tires on this vehicle low on air?' => {
      'Yes' =>
        'Add air to the tires. Make sure you don\'t exceed the pressure level as specified in the vehicle\'s owner\'s manual',
      ['No ## Is there a lot of dirt on the air filter?', 'I don\'t know ## Is there a lot of dirt on the air filter?'] => {
        'Yes' =>
          'Replace the air filter. If this doesn\'t solve the problem, please rerun this diagnostic for further analysis',
        'No' =>
          'A clogged PCV system or faulty oxygen system is likely causing poor gas mileage. Have a mechanic check these systems'
      }
    },
    'A tire wearing out ## Where on the tire are you seeing wear?' => {
      'On one edge of the tire ## What side of the tire is wearing abnormally?' => {
        ['The inside of the tire', 'The outside of the tire'] =>
          'You\'ll need to have an alignment job done on this vehicle'
      },
      'On both edges of the tire' =>
        'One of your tires is underinflated. Add the precise amount of air to bring the tire(s) in question to an appropriate pressure (see the tire sidewall). Refer to this vehicle\'s owner\'s manual for the correct air pressure',
      'In the middle of the tire' =>
        'One of your tires is overinflated. Let some air out of whichever tire is overinflated. Refer to this vehicle\'s owner\'s manual or tire sidewall for the correct air pressure',
      'There is no consistency to the tire wear' =>
        'There is a tire balancing issue. Have a mechanic balance the wheel in question and replace any overly worn tires'
    },
    'Warning light on ## Which warning light did you see?' => {
      'The brake light ## Check the brake fluid level. Refer to your owner\'s manual if you are unsure how to do this. Is the level low? There should be a "low" marking on the reservoir' => {
        'Yes' =>
          'You need to add brake fluid. Buy yourself a can of the brake fluid recommended by the manufacturer and carefully add just enough to top off the brake fluid reservoir. Check your owner\'s manual if you are unsure where this is located',
        'No' =>
          'First off, make sure the parking brake is disengaged, as it may be triggering the light. If that doesn\'t work then you have a pressure imbalance in the system. In this situation you should have this vehicle towed to a reputable garage and serviced'
      },
      'The anti-lock/ABS light' =>
        'Have a mechanic diagnose and fix the ABS system',
      'The oil light ## You will need to check the oil level (please refer to your owner\'s manual if you are unsure how to do this). Is the oil level low?' => {
        'Yes' =>
          'Add enough of the factory recommended oil type and viscosity so that your oil capacity is at -- not above, not below -- appropriate capacity',
        'No' =>
          'Have the vehicle towed to the nearest reputable garage, and ask the mechanic to inspect both the oil pump and oil pressure sensor/wiring'
      },
      'The battery light ## Did the light stay on?' => {
        'Yes' =>
          'First off, have the battery tested to see if it\'s dying. If it tests out ok, you either need to replace the alternator belt or the alternator itself',
        'No, it flickered' =>
          'First off, have the battery tested to see if it\'s dying. If it tests out ok, take this vehicle to a mechanic and have the alternator and its belt inspected. Hopefully, all you\'ll need is to have the belt adjusted or replaced. If not, the alternator itself will have to be replaced'
      },
      'The Check Engine Light' =>
        'This light generally indicates an engine or electrical problem has been detected. If the light has come on in your car it is best to take it to the dealer or a trusted independent mechanic shop and have the diagnostic trouble codes (DTCs) retrieved from the car\'s computer. These will indicate why the light has been activated.'
    },
    'High engine temperature ## When does the gauge read hot?' => {
      'In prolonged, slow traffic ## Is this vehicle equipped with an electric fan?' => {
        'Yes' =>
          'Take this vehicle to a reputable mechanic and have them inspect the electric fan unit',
        'No' =>
          'The issue is a slipping alternator belt or faulty fan clutch. Have this checked out by a professional mechanic',
        'I don\'t know' =>
          'Check the owner\'s manual or ask an expert. Once you know, rerun this diagnostic or, alternatively, visit a mechanic'
      },
      'In hot weather ## Is the coolant level low?' => {
        'Yes' =>
          'Check your coolant level, as lack of coolant will cause the engine to overheat. Top off the radiator with coolant if need be',
        'No' =>
          'The cooling system may be clogged and will have to be backflushed',
        'Don\t know' =>
          'Your coolant level may be low. Refer to your owner\'s manual if you are unsure how to check this. Alternatively, take the car to a professional mechanic'
      },
      'Always, beginning shortly after the engine is started ## Is the coolant level low?' => {
        'Yes' =>
          'Lack of coolant is causing the engine to overheat. Top off the radiator with coolant',
        ['No ## Did one of the coolant hoses collapse?', 'I don\'t know ## Did one of the coolant hoses collapse?'] => {
          'Yes' =>
            'Replace the hose which is collapsing. Any auto parts store will carry a new hose',
          'No' =>
            'Take this vehicle to a reputable repair garage and ask the mechanic to determine if the problem lies with the water pump or the thermostat. Have the necessary parts replaced',
          'I don\'t know' =>
            'Visit a mechanic for further diagnosis'
        }
      },
    },
    'Steam ## Where is the steam coming from?' => {
      'From under the hood' =>
        'Check the radiator cap when the engine is cold. If anything seems odd about the radiator cap, replace it and see if this corrects the boil over problem. Otherwise, have the entire cooling system backflushed in order to remove all of the old coolant. Refill with a 50/50 mixture of water and anti-freeze',
      'From the exhaust' =>
        'This is normal and just condensation steaming off'
    }
  }
}

sounds_like = {
  'Sounds Like ## What do you hear?' => {
    'Pinging ## When does the engine ping?' => {
      'While driving at high altitude' => {
        'Have you been using regular grade gasoline?' => {
          'Yes' =>
            'Use a higher octane gasoline from now on, or at least when you anticipate driving at altitude',
          'No' =>
            'There isn\'t too much you can do since this is just a normal consequence of driving at higher altitudes. However, you may want to try using a high octane fuel the next time you anticipate driving'
        }
      },
      'When driving uphill and the engine temperature begins to climb' =>
        'In general, pre-ignition and thus power loss are just normal consequences of a very hot engine. Have a mechanic check your cooling system',
      'Seemingly at random' =>
        'Take this vehicle to a garage and ask the mechanic to test the EGR valve. If the valve is indeed bad, have it replaced. Also, check the spark plugs for carbon deposits'
    },
    'The engine is running roughly' => {
      'At idle' =>
        'Chances are the engine is misfiring in one or more cylinders',
      'At highway speeds' =>
        'Replace both the spark plugs and wires'
    },
    'The engine backfires ## When does this occur?' => {
      'During normal driving ## Does happen only while slowing down?' => {
        'Yes' =>
          'Take this vehicle to a garage and ask the mechanic to check the air injection system, in particular its diverter valve',
        'No' =>
          'Take this vehicle to a garage and have the mechanic check the valves and timing. The valves could be burned or simply out of adjustment. Timing problems are generally caused by a slipping timing belt or chain'
      },
      'Right after starting the car ## Does this starting problem only happen in wet conditions?' => {
        'Yes' =>
          'There is probably moisture in the distributor cap. If there is, have it replaced',
        'No' =>
          'It is likely there is a problem with the fuel injection system. Have a professional mechanic look at the car'
      }
    },
    'Ticking / tapping ## Does the oil light come on?' => {
      'Yes' =>
        'In order to boost engine lubrication, the oil pressure has to be increased, and the oil pressure is probably low due to either a clogged oil pan screen or a bad oil pump. Ask a mechanic to determine the exact cause of this engine\'s low oil pressure',
      'No ## Does this engine have a low oil level?' => {
        'Yes' =>
          'Add enough of the factory recommended oil type and viscosity so that your oil capacity is at -- not above, not below -- appropriate capacity',
        'No' =>
          'Loose valves or a leaking exhaust manifold are likely the issue'
      }
    },
    'Squealing noise ## Where is the squealing noise coming from?' => {
      'The engine' =>
        'This generally indicates either a worn drive belt or faulty alternator. Apply some silicone spray on the underside of the drive belt. This may provide you with some temporary relief of this squealing noise. Otherwise, you\'ll need to take this vehicle to a repair garage and have a mechanic make the necessary repairs',
      'The brakes ## Does the pedal go close to the floor?' => {
        'Yes' =>
          'This vehicle needs new brake pads. The noise you are hearing is the brake pad wear sensor. It is designed to let you know your pads are wearing thin',
        'No' =>
          'The high frequency vibration of the brake pads is causing squeal. This is normal behavior for some cars'
      },
      'From the tires ## Check the tire pressure. Are the tire pressure readings unusually low or high?' => {
        'Yes' =>
          'Add or release air from whichever tires aren\'t properly inflated. Hopefully this will eliminate the screeching',
        'No' =>
          'Have an alignment job done on this vehicle'
      }
    },
    'Sputter and cough ## When does this happen?' => {
      'During idle but not while driving' =>
        'It is likely something has gone wrong with the valves. You will need a valve job',
      'During normal driving ## You will need to either check your spark plugs or have a mechanic check them. Once removed, do the spark plugs look dirty?' => {
        'Yes' =>
          'Replace all the spark plugs',
        'No' =>
          'It is likely you have a problem with either the fuel injection system or a bad coil/spark plug wire. It is best to have this checked out by a mechanic'
      }
    },
    'Brakes make noise ## What kind of noise are your brakes making?' => {
      'My brakes make an unmistakable grinding noise when I use them' =>
        'Your brake pads need to be replaced and your rotors may need replacement or resurfacing',
      'My brakes make an odd sort of rattling sound when I use them' =>
        'Your brake pads need to be replaced and your rotors may need replacement or resurfacing',
      'There is a kind of "click" coming from the front of the vehicle' =>
        'Take this vehicle to a reputable repair shop and ask the mechanic to check the suspected brake unit. A loose or worn front suspension component may also be to blame'
    },
    'Clunking sound ## When do you hear this clunk?' => {
      'When shifting from park into drive ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No' =>
          'Take this vehicle to a garage and have the mechanic check both the engine mounts and driveline joints. Have this problem taken care of soon since any jarring effect will eventually take its toll on the transmission'
      },
      'When releasing the gas pedal' =>
        'Take this vehicle to a garage and have the mechanic check the driveline joints (either CV-Joints or U-Joints, depending if this vehicle is front- or rear-wheel drive, respectively). Have this problem taken care of soon since the jarring effect will eventually take its toll on the transmission',
      'During normal driving ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No' =>
          'Take this vehicle to a transmission specialist. It will be necessary for the mechanic to open up the transmission for this (there\'s just no way of knowing otherwise)'
      },
      'When driving over bumps ## Is the sound coming from the front or rear of the car?' => {
        'Front' =>
          'The front shocks or front strut cartridges are worn or faulty. Have them inspected and replaced if need be',
        'Rear' =>
          'The rear shocks or rear strut cartridges are worn or faulty. Have them inspected and replaced if need be',
        'I don\'t know' =>
          'Either your front or rear shocks or strut cartridges are worn/ faulty. Have them inspected and replaced if need be'
      },
      'Only while turning ## Is this vehicle front-wheel drive?' => {
        'Yes' =>
          'A faulty CV Joint is likely causing the noise. Take this vehicle to a garage and ask the mechanic to find out exactly what is causing the clicking noise',
        'No' =>
          'Have a mechanic inspect the front end of this vehicle and make the necessary repairs. Take care of this problem soon since the clicking noise is a warning of something more serious to come',
        'I don\t know' =>
          'Have a mechanic inspect the vehicle. If it is front-wheel drive, a faulty CV Joint is likely'
      },
    },
    'A clicking sound ## Are the dash lights out or extremely dim?' => {
      'Yes' =>
        'The solenoid needs to be replaced. We recommend having a professional mechanic do the work',
      'No ## Take a look at the battery terminals. Is there a noticeable amount of corrosion buildup on the terminals?' => {
        'Yes' =>
          'Have a mechanic clean the battery terminals. If this doesn\'t help the issue, have your battery tested. It may be dead',
        'No' =>
          'Have the battery tested. Chances are it is dead and will need to be replaced. This could also signify an issue with the starter'
      }
    }
  }
}

smells_like = {
  'Smells like ## What do you smell?' => {
    'Rotten egg smell ## Check the air filter. Is it dirty?' => {
      'Yes' =>
        'Replace the air filter',
      'No' =>
        'Have the fuel injection sensor checked by a mechanic'
    },
    'Muggy smell from A/C vents, along with poor cooling' =>
      'The drain pan of the A/C evaporator unit isn\'t draining. It is best to have an A/C specialist look at this, as the clog may be further up in the system and difficult to access'
  }
}

feels_like = {
  'Feels Like ## What do you feel?' => {
    'Shaking' => {
      'While braking' => {
        'The brake pedal ## When braking, is there also vibration coming mainly from the front end?' => {
          ['Yes', 'I don\'t know'] =>
            'There is an alignment issue with the front brake pads and discs. Take this vehicle to a reputable garage and ask the mechanic to check the front wheel bearings for wear or looseness and the front rotors for "warp".',
          'No ## Does the brake pedal vibrate only during very heavy braking?' => {
            'Yes' => 
              'There is nothing wrong. This is the anti-lock braking system pulsing the brakes. It is completely normal',
            'No' =>
              'There is an alignment issue between the rear brake pads and discs. Take this vehicle to a reputable garage and ask the mechanic to first check the rear wheel bearings for wear or looseness'
          }
        },
        ['The whole car shakes', 'The steering wheel shakes'] =>
          'There is an alignment issue with the front brake pads and discs. Take this vehicle to a reputable garage and ask the mechanic to check the front wheel bearings for wear or looseness and the front rotors for "warp".'
      },
      'During idle' =>
        'Chances are the engine is misfiring in one or more cylinders',
      'When accelerating ## Did this start out as a relatively small issue that has gradually become worse?' => {
        'Yes' =>
          'Take this vehicle to a garage and ask the mechanic to check for a vacuum leak',
        'No ## Does this typically occur on cold, wet mornings when the engine is cold?' => {
          'Yes' =>
            'Moisture in the distributor cap is likely causing a misfire',
          'No' =>
            'Take this vehicle to a garage and have the mechanic check the throttle position sensor'
        },
        'Don\t know' =>
          'Take this vehicle to a garage and have the mechanic check the throttle position sensor'
      },
      'While driving at certain speeds ## Where is this vibration coming from?' => {
        'The front of the car' =>
          'Have the front wheels balanced',
        'The rear of the car' =>
          'Have the rear wheels balanced',
        'I am unsure where it is coming from' =>
          'Have all four wheels balanced'
      },
    },
    'Abnormal braking ## What most closely describes your brake issue?' => {
      'My brake pedal travels much farther (closer to the floorboard) than it used to ## Did this problem seem to coincide with any work performed on the vehicle?' => {
        'Yes' =>
          'It is likely the master cylinder push rod is not properly adjusted',
        'No ## Is the brake fluid level low?' => {
          'Yes' =>
            'You need to add brake fluid. Unscrew the top of the reservoir and carefully pour in the appropriate amount. Do not keep the cap off any longer than necessary',
          'No' =>
            'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us'
        }
      },
      'When I apply light pressure to the brake pedal, the pedal travels straight to the floorboard' =>
        'It is likely there is an internal leak in the master cylinder. This vehicle will need either a new or rebuilt master cylinder',
      'The brake pedal feels soft and mushy' =>
        'This is often caused by air bubbles forming in the brake lines. If the brakes were recently worked on, maybe the mechanic did not fully "bleed" the brake system. Or worse, there could be a leak somewhere in the brake system which is consequently allowing air to enter. In either case, take the vehicle to a reputable shop and ask the mechanic to check for leaks and to bleed the system',
      'When I brake, the car pulls to one side ## Are the front tires unevenly inflated?' => {
        'Yes' =>
          'Add air to the tire with lower air pressure (find the recommended pressure in your owner\'s manual or tire sidewall). The imbalance in tire pressure is causing pull',
        'No ## To check for further problems, you will need to remove the front tires and examine the brake discs and pads. If you are not comfortable with this, take the car to a mechanic. Are the brake discs or pads on one side thicker than those of the other side?' => {
          'Yes' =>
            'Depending on what did not match up from side-to-side (either pads or rotors), the vehicle will need a new, matching set',
          'No' =>
            'It is likely that you have a front alignment issue. Have the alignment checked. If this is not the problem, then one of the front brake calipers is probably either faulty or leaking. Have a mechanic look at the car right away'
        }
      },
      'When I take my foot off the brake pedal, it feels like one wheel is still braking ## Is this happening in the front of the car?' => {
        'Yes' =>
          'A front brake caliper or piston is seized. Take this vehicle to a reputable repair shop and ask the mechanic to inspect the front brake unit which doesn\'t seem to be fully releasing',
        'No' =>
          'A rear brake caliper or piston is seized. Take this vehicle to a reputable repair shop and ask the mechanic to inspect the rear brake unit which doesn\'t seem to be fully releasing'
      },
      'When I take my foot off the brake pedal, it feels like all four wheels are still trying to stop ## Is the brake pedal sticking when you step on it?' => {
        'Yes' =>
          'Incomplete retraction of the brake pedal is causing the brakes to drag. Correct whatever it is that is causing the brake pedal to bind (like bunched up floor carpet). If you can\'t fix it yourself, take this vehicle to a garage as soon as possible',
        'No' =>
          'Have a mechanic inspect this vehicle\'s master cylinder. A few items you may want check for are: the master cylinder push rod, a swollen primary piston cup and a blocked bypass port'
      },
      'My brakes will stop the car, but it takes a worrying amount of force to get that to happen' =>
        'This is most likely a problem with the power brake unit. Have it replaced',
      'When I brake, one of the wheels locks up!' =>
        'It is likely that the brake linings are contaminated. Take this vehicle to a garage and ask the mechanic to check the brake linings for contamination'
    },
    'Vehicle is sluggish ## When does this happen?' => {
      'When I take off from a dead stop ## During this sluggish initial forward movement, does the engine rev up?' => {
        'Yes' =>
          'The clutch associated with first gear is likely slipping. Unfortunately, this situation usually means that a tear down of the transmission is necessary in order to fix or replace the slipping clutch',
        'No ## Check the transmission fluid level under the hood (look in your owner\'s manual if you are unsure as to where this is). There are \'high\' and \'low\' indicators inside. Is it too high or too low?' => {
          'Yes' =>
            'A wrong fluid level is affecting the hydraulics of the transmission. If the level is too high, you can drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
          'No' =>
            'If the fluid level looks good, chances are there is something wrong with the fluid itself. Is the fluid milky or black? Does it have bubbles? If so, have the transmission fluid and filter changed',
        }
      },
      'After selecting "Reverse", there\'s an annoying delay before the vehicle will actually start moving backwards ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of the transmission. If the level is too high, you can drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No ## Di you notice the fluid to be milky-like and/or have bubbles? Is it brown or blackish i color?' => {
          'Yes' =>
            'Change the transmission filter and fluid. Contaminated fluid is affecting the hydraulics of transmission',
          'No' =>
            'Something is causing poor fluid pressure buildup. Have the transmission fluid and filter changed'
        }
      },
      'When I need passing power and press the accelerator to the floor ## Is the transmission downshifting?' => {
        'Yes' =>
          'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us',
        'No' =>
          'There is a problem with full throttle indicator mechanism. Have it checked by a mechanic'
      },
    },
    'Awkward shifting ## What is wrong with the transmission\'s shifting?' => {
      'It shifts too early ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'An incorrect fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No ## Is the transmission computer controlled?' => {
          ['Yes', 'I don\'t know'] =>
            'A faulty electronic sensor is likely. Take this vehicle to a transmission specialist and have them run some diagnostic tests',
          'No' =>
            'There is either a problem with the throttle valve linkage or a faulty governor. Get the valve linkage adjusted and investigate the governor if issues persist'
        }
      },
      'It is holding gears longer than normal and takes too long to shift ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No ## If the fluid level looks good, chances are there is something wrong with the fluid itself. Is the fluid milky or black? Does it have bubbles?' => {
          'Yes' =>
            'Change the transmission fluid and filter, and have the transmission inspected if the problem persists',
          'No' =>
            'A faulty electronic sensor is likely, or there may be an issue with the throttle valve linkage or governor. Take this vehicle to a transmission specialist and have them run some diagnostic tests'
        }
      },
      'When accelerating, the transmission seems to shift randomly ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No ## Did you notice the fluid to be milky-like and/or have bubbles? Is it brown or blackish in color?' => {
          'Yes' =>
            'Change the transmission filter and fluid. Contaminated fluid is affecting the hydraulics of transmission',
          'No' =>
            'Chances are there is either a sticking pressure valve or a leaking vacuum hose. Replace the vacuum hose (if the transmission has one) and have a mechanic run some diagnostics if the issue persists'
        }
      },
      'When accelerating, the engine sometimes revs wildly before upshifting ## Check the transmission fluid level. Is it low?' => {
        'Yes' =>
          'A wrong fluid level is affecting the hydraulics of transmission. If the level is too high, you can simply drain some out (refer to the owner\'s manual for instructions). If the level is too low, add some fluid (again, refer to the owner\'s manual)',
        'No ## Did you notice the fluid to be milky-like and/or have bubbles? Is it brown or blackish in color?' => {
          'Yes' =>
            'Change the transmission filter and fluid. Contaminated fluid is affecting the hydraulics of transmission',
          'No' =>
            'The first thing to do is to have the bands adjusted (if this vehicle\'s transmission has bands and further, if they are the adjustable type). This procedure is fairly inexpensive and it may correct the problem. Otherwise, take this vehicle to a transmission repair specialist and have them determine if the fluid pump is the culprit'
        }
      },
      'I have one gear that\'s giving me trouble, but the rest seem fine' =>
        'You will have to get a mechanic to do a transmission tear down in order to determine the exact cause of the problem. It may be a faulty clutch or band'
    },
    'Vehicle "rides" uncomfortably ## When does this happen?' => {
      'Always ## How would you best describe the vehicle ride?' => {
        'Excessively harsh or stiff ## Are your tires overinflated?' => {
          'Yes' =>
            'The tires are overinflated. Let some air out of the tires. Use a tire pressure gauge to make sure the tires are at the correct pressure (see the tire sidewall or the tire manufacturer\'s specification)',
          'No' =>
            'You\'ll need to take this vehicle to a reputable shop and ask the mechanic to inspect the shocks/strut cartridges. More specifically, ask him to determine if one or more is indeed seized'
        },
        'Squishy or bouncy' => 
          'Your vehicle\'s shocks and/or strut cartridges need to be replaced',
        'Neither of these' =>
          'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us',
      },
      'The front of the vehicle dips when braking' =>
        'The front shocks or front strut cartridges are worn or faulty. Have them inspected and replaced if need be'
    },
    'Abnormal steering ## When does this change in steering feel occur?' => {
      'Constantly, during normal driving ## Does your steering feel loose and sloppy, especially at higher speeds?' => {
        'Yes ## Are the tire pressure readings higher than the recommended maximum pressure displayed on the side of the tire?' => {
          'Yes' =>
            'Let some air out of each tire. Refer to this vehicle\'s owner\'s manual for the correct air pressure. Doing this should improve the steering problem',
          'No' =>
            'Loose or worn steering or front suspension components are the issue. Have a mechanic inspect this vehicle and make any necessary repairs'
        },
        'No' =>
          'Check the power steering fluid level (please refer to the vehicle\'s owner\'s manual for instructions). If the level is low, add some fluid. There\'s probably a leak somewhere in the system, in which case you\'ll need have it fixed'
      },
      'Only at certain speeds ## Is the steering wheel shaking at a certain speed?' => {
        'Yes' =>
          'Have the front wheels balanced',
        'No' =>
          'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us',
      },
      'When exiting a turn' => {
        'Yes' =>
          'Have an alignment job done on this vehicle',
        'No' =>
          'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us',
      },
      'When the engine is cold' =>
        'The control valve assembly will need to be replaced. However, note that most garages will only replace the entire steering rack and pinion unit',
      'Seemingly at random' =>
        'If the steering stiffens up at random, you\'ll need to have the power steering pump replaced',
      'The vehicle pulls slightly to the left or right ## Do your front tires have uneven pressures?' => {
        'Yes' =>
          'Make sure both front tires are at the correct pressure - this should correct the slight "pull" of the vehicle. Refer to this vehicle\'s owner\'s manual if you aren\'t sure of the correct tire pressure',
        'No' =>
          'Have the alignment checked. If that isn\'t the issue, you may have a dragging front brake, though this is much more rare',
      }
    }
  }
}

not_working = {
  'Not Working ## What isn\'t working properly?' => {
    'Poor gas mileage ## Are the tires on this vehicle low on air?' => {
        'Yes' =>
          'Add air to the tires. Make sure you don\'t exceed the pressure level as specified in the vehicle\'s owner\'s manual',
        ['No ## Is there a lot of dirt on the air filter?', 'I don\'t know ## Is there a lot of dirt on the air filter?'] => {
          'Yes' =>
            'Replace the air filter. If this doesn\'t solve the problem, please rerun this diagnostic for further analysis',
          'No' =>
            'A clogged PCV system or faulty oxygen system is likely causing poor gas mileage. Have a mechanic check these systems'
        }
    },
    'I turn off the car, but the engine keeps running ## When does this occur?' => {
      'While idling ## Does the engine idle at high rpm?' => {
        'Yes' =>
          'The engine idle speed must be lowered. This is a very technical process and a professional mechanic is recommended',
        'No' =>
          'The fuel injectors may be leaking'
      },
      'During normal driving ## Does this only happen when the engine is hot?' => {
        'Yes' =>
          'Low quality fuel is causing engine run on',
        'No ## Have you been filling your gas tank with low octane (i.e. regular) gas?' => {
          'Yes' =>
            'Extreme internal engine heat is causing run on',
          'No' =>
            'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us',
        }
      }
    },
    'My car won\'t start ## Which of the following symptoms most closely describe the issue with your car?' => {
      'It makes a clicking sound or no noise whatsoever ## Are the dash lights out or extremely dim?' => {
        'Yes' =>
          'Replace the starter and solenoid',
        'No ## Take a look at the battery terminals. Is there a noticeable amount of corrosion buildup on the terminals?' => {
          'Yes' =>
            'Have a mechanic clean the battery terminals. If this doesn\'t help the issue, have your battery tested. It may be dead',
          'No' =>
            'Have the battery tested. Chances are it is dead and will need to be replaced. This could also signify an issue with the starter'
        }
      },
      'It tries to start and makes some noise while doing so ## What kind of noise does it make?' => {
        'Just a clicking sound ## Are the dash lights out or extremely dim?' => {
          'Yes' =>
            'Replace the starter and solenoid',
          'No ## Take a look at the battery terminals. Is there a noticeable amount of corrosion buildup on the terminals?' => {
            'Yes' =>
              'Have a mechanic clean the battery terminals. If this doesn\'t help the issue, have your battery tested. It may be dead',
            'No' =>
              'Have the battery tested. Chances are it is dead and will need to be replaced. This could also signify an issue with the starter'
          }
        },
        'A spinning and whirring sound' =>
          'There is a problem with your starter. Have the starter wiring checked and replace the starter if necessary',
        'A grinding sound' =>
          'It is likely you have a bad starter drive or a worn ring gear. Have it towed to a shop and replace the starter or ring gear as needed'
      },
      'It starts and then dies right away ## Is the vehicle out of gas?' => {
        'Yes' =>
          'Fill the gas tank and try to start the car again',
        'No ## Does this happen mostly in wet, damp conditions?' => {
          'Yes' =>
            'It is likely moisture has worked its way into the distributor cap. You may want to replace it with a new factory item',
          'No ## Check the air filter. Does it appear to be clogged?' => {
            'Yes' =>
              'Replace the dirty air filter with a new one',
            'No' =>
              'It is likely you have a damaged timing belt. Have it inspected and replaced if need be'
          }
        }
      }
    },
    'I can shift, but the vehicle doesn\'t move ## Check the transmission fluid level. Is it low?' => {
      'Yes' =>
        'Add the appropriate level of transmission fluid',
      'No' =>
        'Since this vehicle isn\'t drivable, you\'ll need to have it towed to a garage. Ask the mechanic to check both the fluid pump and gear selector linkage. If he can\'t find the culprit, don\'t be surprised if he tells you the vehicle needs a new transmission. This isn\'t unreasonable since, after all, none of the gears work'
    },
    'The vehicle won\'t shift into park' => 
      'Take this vehicle to a garage and have the mechanic check the gear selector linkage and parking lock pawl. Always use the emergency brake to keep the vehicle from rolling when it\'s parked',
    'Lack of hot/cold air ## What climate control system is giving you problems?' => {
      'The air conditioning system ## When does your A/C performance decrease?' => {
        'Always ## How would you describe the change in performance?' => {
          'Slowly over time' =>
            'Have the condenser checked for dirt and debris and cleaned if necessary. This may fix the problem. If not, you\'ll need to take this vehicle to a garage and ask the mechanic to "charge" the A/C system (i.e. add refrigerant). Make sure to check for leaks',
          'Sudden' =>
            'There is a major refrigerant leak or A/C electrical problem. You can open the hood and look for obvious leaks, but it is best to have an expert check the system'
        },
        'Every once in a while ## Does the A/C sometimes blow warm air, but only when the engine is hot?' => {
          'Yes' =>
            'Actually, nothing is wrong. The compressor is automatically disengaging to keep the engine from overheating. This is normal behavior',
          'No' =>
            'It is likely that either the A/C expansion valve is freezing up, that your have a failing A/C compressor or an intermittent electrical issue. Have an expert take a look at it'
        }
      },
      'The heating system ## Is your heater not blowing warm air even after the engine heats up?' => {
        'Yes ## Does this vehicle have an automatic temperature control system?' => {
          'Yes' =>
            'Take this vehicle to a specialist for further analysis. It is likely you have a problem with the ambient air sensor or blend door, but we can\'t be sure',
          'No' =>
            'Take this vehicle to a shop specializing in heater repair and have the mechanic inspect both the heater control valve and the device that activates the valve, and have the necessary repairs done'
        },
        'No' =>
          'We\'re sorry, but based on the information provided we are unable to determine the exact cause of your issue. But don\'t give up hope; we have a panel of mechanics available to help you. Feel free to leverage their wealth of automotive knowledge - it\'s on us'
      },
      'No air is coming out of the vents ## What best describes your issue?' => {
        'My climate control vents barely create any airflow at all, even with the fan cranked' =>
          'There is a problem with the blower or a physical blockage of the ducts. Check the fresh air intake port for debris which may be blocking it. If this does not fix the problem, you\'ll need to take this vehicle to a mechanic who has some expertise in A/C and heating systems',
        'My climate control vents don\'t offer any airflow, period, at any fan setting' =>
          'The problem is likely a blown fuse or failed blower motor. Check the fuse and change it if need be. If this does not fix the problem, take the vehicle to a specialist'
      }
    },
    'Engine feels weak ## Is this vehicle\'s top speed significantly less than it once was?' => {
      'Yes' =>
        'Take this vehicle to a garage and have the mechanic verify that the catalytic converter is indeed clogged',
      'No ## Does the engine run roughly, especially when idling?' => {
        'Yes' =>
          'Replace the spark plugs and spark plug wires',
        'No' =>
          'Have the fuel injectors cleaned'
      }
    },
    'The engine stalls ## When does the engine stall?' => {
      'While idling ## Does the engine only stall when it is cold?' => {
        'Yes' =>
          'You\'ll need to have a mechanic verify that the cold start valve is faulty. If this is indeed the case, have it replaced',
        'No ## Will the engine stay running if you lightly step on the gas pedal?' => {
          'Yes' =>
            'You\'ll need to have a mechanic verify that the idle air bypass valve is faulty. If this is indeed the case, have it replaced',
          'No' =>
            'You\'ll need to have a mechanic verify that the fuel pressure regulator is faulty. If this is indeed the case, have it replaced'
        }
      },
      'While accelerating ## Over time, has this problem gradually become more frequent?' => {
        'Yes' =>
          'Take this vehicle to a garage and ask the mechanic to check for a vacuum leak. In particular, have the mechanic check both the EGR and PCV valves since these are items that are often found to be the source of vacuum leaks',
        'No ## Does this typically occur on cold, wet mornings when the engine is cold?' => {
          'Yes' =>
            'Moisture in the distributor cap is causing a misfire',
          'No' =>
            'Take this vehicle to a garage and have the mechanic check the throttle position sensor. Tell the mechanic exactly what you learned here. This is very important in that it shows you know something about the nature of this acceleration problem'
        }
      },
      'During normal driving ## Does the engine stall only when it is abnormally hot?' => {
        'Yes' =>
          'When vapor lock strikes, the only thing you can do is wait for the engine to cool down. The real question is why the engine is getting so hot to begin with? Have a mechanic check your cooling system',
        'No' =>
          'You\'ll need to have a mechanic verify that the fuel pressure regulator is faulty. If this is indeed the case, have it replaced'
      }
    }
  }
}

def traverse(symptoms, parents = nil)
  symptoms.each do |symptom, children|
    created = Array(symptom).map do |description|
      comment = nil
      description, comment = description.split(' ## ')
      comment = children if children.is_a? String
      s = Symptom.create(description: description, comment: comment)
      parents.each { |p| p.children << s; p.save } if parents
      s
    end

    traverse(children, created) if children.respond_to?(:each)
  end
  nil
end

if Symptom.count == 0
  [looks_like, sounds_like, smells_like, feels_like, not_working].each { |symptoms| traverse(symptoms) }
end
