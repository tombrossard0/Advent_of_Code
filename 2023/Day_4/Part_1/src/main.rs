use std::io;
use std::io::prelude::*;
use std::io::BufReader;
use std::fs::File;

fn read_card(line : Result<String, std::io::Error>) -> i32 {
    match line {
        Ok(line) => { 
            println!("{line}");
            let mut read_win_nums = true;
            let mut words = line.split_ascii_whitespace();
            words.next();
            words.next();

            let mut total = 0;
            let mut wins = Vec::new();

            for word in words {
                if word.chars().next().unwrap() == '|' {
                    read_win_nums = false;
                }
                else if read_win_nums {
                    wins.push(word.parse::<i32>().unwrap());
                    println!("You can win with {word}");
                }
                else {
                    let num = word.parse::<i32>().unwrap();
                    if wins.contains(&num) {
                        println!("You have {num}!");
                        if total == 0 {
                            total += 1;
                        }
                        else {
                            total *= 2;
                        }
                    }
                }
            }

            return total;
        }
        _ => {
            return 0;
        }
    }
}

fn main() -> io::Result<()> {
    let f = File::open("inputs/input.txt")?;
    let reader = BufReader::new(f);

    let mut total = 0;
    for line in reader.lines() {
        let res = read_card(line);
        total += res;
        println!("Res : {res}");
    }

    println!("Total : {total}");
    Ok(())
}