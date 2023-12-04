use std::io;
use std::io::prelude::*;
use std::io::BufReader;
use std::fs::File;

fn read_card(line : &Result<String, std::io::Error>) -> usize {
    match line {
        Ok(line) => { 
            //println!("{line}");
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
                    //println!("You can win with {word}");
                }
                else {
                    let num = word.parse::<i32>().unwrap();
                    if wins.contains(&num) {
                        //println!("You have {num}!");
                        total += 1;
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

    let mut occ_cards = Vec::new();
    let mut total = 0;

    let mut i = 0;
    for line in reader.lines() {
        if i >= occ_cards.len() {
            occ_cards.push(1);
        }
        let mut j = 0;
        while j < occ_cards[i] {
            let res = read_card(&line);

            let mut k = i;
            while k < i + res {
                k += 1;
                if k >= occ_cards.len() {
                    occ_cards.push(1);
                }
                occ_cards[k] += 1;
            }

            total += 1;
            //println!("Res : {res}");
            j += 1;
        }
        
        i += 1;
    }

    println!("Total : {total}");
    Ok(())
}