defmodule Advent2022.Day07.Test do
  use ExUnit.Case
  import Advent2022.Day07

  @sample_input "$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k"

  test "read_tree" do
    assert build_directory_tree(@sample_input) ==
      { 14848514 + 8504156,
        %{ "a" => { 29116 + 2557 + 62596,
                    %{"e" => {584, %{}}}},
           "d" => {4060174+ 8033020 + 5626152 + 7214296, %{}}  }
      }
  end

  test "determine_disk_usage" do
    assert determine_disk_usage(build_directory_tree(@sample_input)) ==
      {48381165, %{"a" => {94853, %{"e" => {584, %{}}}}, "d" => {24933642, %{}}}}
  end

  test "part1" do
    sizes = build_directory_tree(@sample_input)
    |> determine_disk_usage()
    |> tree_to_list()
    |> Enum.filter(fn s -> s <= 100000 end)
    assert Enum.sum(sizes) == 95437
  end
end
